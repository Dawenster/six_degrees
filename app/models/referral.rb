class Referral < ActiveRecord::Base
  belongs_to :user

  validates :user, :email, presence: true
end
