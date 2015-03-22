class Dream < ActiveRecord::Base
  belongs_to :user
  has_many :connections

  validates :description, :dream_type, :user_id, :presence => true, allow_blank: false

  def self.dreams_with_user_info
    dreams = []
    Dream.all.each do |dream|
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
end
