class Tag < ActiveRecord::Base
  has_and_belongs_to_many :dreams, uniq: true

  scope :alphabetical, -> { order(:name) }
end