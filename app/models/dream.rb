class Dream < ActiveRecord::Base
  belongs_to :user
  has_many :connections
  has_many :messages, :dependent => :destroy

  validates :description, :dream_type, :user_id, :presence => true, allow_blank: false

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

  def icon
    if dream_type == "Personal"
      return "<i class='fa fa-heart'></i>"
    else
      return "<i class='fa fa-briefcase'></i>"
    end
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
    self.connections.order("created_at ASC").map{|c|[c.user.full_name, c.user.id]}
  end

  def messages_by_user
    messages = {}
    self.messages.order("created_at ASC").each do |message|
      messages[message.user] ||= []
      messages[message.user] << message
    end
    return messages
  end
end
