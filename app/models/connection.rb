class Connection < ActiveRecord::Base
  belongs_to :dream
  belongs_to :user

  validates :dream_id, :user_id, :presence => true, allow_blank: false

  def send_status_to_angular(type)
    return nil if accepted.nil?  
    if type == "accept"
      return accepted
    else
      return !accepted
    end
  end
end
