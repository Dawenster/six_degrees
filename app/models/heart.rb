class Heart < ActiveRecord::Base
  belongs_to :dream
  belongs_to :user

  validates :user, :dream, presence: true
end
