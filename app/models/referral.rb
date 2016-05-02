class Referral < ActiveRecord::Base
  belongs_to :user
  belongs_to :dream

  validates :email, :referrer_name, presence: true
end
