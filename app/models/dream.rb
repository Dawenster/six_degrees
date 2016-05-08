class Dream < ActiveRecord::Base
  belongs_to :user
  has_many :connections
  has_many :messages, :dependent => :destroy
  has_many :hearts, :dependent => :destroy
  has_many :referrals
  has_and_belongs_to_many :tags, uniq: true
  has_many :summaries

  validates :description, :user_id, :presence => true, allow_blank: false
  validate :has_at_least_one_tag

  DREAM_LENGTH_IN_CHARS = 150
  DREAM_RESPONSE_LENGTH_IN_CHARS = 500

  def self.dreams_with_user_info
    dreams = []
    Dream.all.shuffle.each do |dream|
      dreams << {
        :user => dream.user,
        :content => dream
      }.as_json
    end
    return dreams
  end

  def self.dreams_with_user_info_and_user_specific_messages(user)
    dreams = []
    Dream.all.shuffle.each do |dream|
      dreams << {
        :user => dream.user,
        :content => {
          :dream => dream,
          :messages => dream.messages_involving(user)
        }
      }.as_json
    end
    return dreams
  end

  def messages_involving(user)
    return self.messages.select { |message| message.user == user || message.recipient == user }
  end

  def helped_by(user)
    self.connections.map{|c|c.user}.include?(user)
  end

  def connection_by(user)
    self.connections.select{|c| c.user == user}.first
  end

  def num_approved
    self.connections.select{|c|c.accepted}.count
  end
    
  def num_declined
    self.connections.select{|c|c.accepted == false}.count
  end

  def helpers_select
    self.connections.order("created_at ASC").map do |c|
      [c.user.full_name, c.user.id]
    end
  end

  def messages_by_user
    messages = {}
    self.messages.order("created_at ASC").each do |message|
      if message.user == self.user
        messages[message.recipient] ||= []
        messages[message.recipient] << message
      else
        messages[message.user] ||= []
        messages[message.user] << message
      end
    end
    return messages
  end

  private

  def has_at_least_one_tag
    errors.add(:base, "Please select at least one tag") if tags.empty?
  end
end
