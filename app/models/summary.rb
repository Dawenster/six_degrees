class Summary < ActiveRecord::Base
  belongs_to :user
  belongs_to :dream

  validates :user, :content, presence: true
end
