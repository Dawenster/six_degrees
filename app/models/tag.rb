class Tag < ActiveRecord::Base
  has_and_belongs_to_many :dreams, uniq: true

  scope :alphabetical, -> { order(:name) }

  validates :name, presence: true, allow_blank: false

  TRAVEL = "Travel"
  CAREER_GOALS = "Career Goals"
  PERSONAL_GROWTH = "Personal Growth"
  FOR_A_BETTER_WORLD = "For A Better World"
  FAN_CLUB = "Fan Club"
  
end
