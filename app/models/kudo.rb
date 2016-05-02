class Kudo < ActiveRecord::Base
  belongs_to :giver, :class_name => 'User', :foreign_key => 'giver_id'
  belongs_to :receiver, :class_name => 'User', :foreign_key => 'receiver_id'

  validates :giver, :receiver, presence: true
  validate :can_only_kudos_once

  private

  def can_only_kudos_once
    errors.add(:base, "Kudos already given to this user") if Kudo.where(giver_id: giver_id, receiver_id: receiver_id).any?
  end
end
