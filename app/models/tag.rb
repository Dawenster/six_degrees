class Tag < ActiveRecord::Base
  has_and_belongs_to_many :dreams, uniq: true

  scope :alphabetical, -> { order(:name) }

  validates :name, presence: true, allow_blank: false
end
