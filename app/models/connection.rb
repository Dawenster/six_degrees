class Connection < ActiveRecord::Base
  belongs_to :dream
  belongs_to :user

  validates :dream_id, :user_id, :presence => true, allow_blank: false

  def receiver
    self.dream.user
  end
end
