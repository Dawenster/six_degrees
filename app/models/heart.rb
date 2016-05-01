class Heart < ActiveRecord::Base
  belongs_to :dream
  belongs_to :user

  validates :user, :dream, presence: true
  validate :can_only_heart_dream_once

  private

  def can_only_heart_dream_once
    errors.add(:base, "User has already hearted this dream") if user.already_hearted?(dream)
  end
end
