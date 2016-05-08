class Summary < ActiveRecord::Base
  belongs_to :user
  belongs_to :helper, :class_name => "User", :foreign_key => "helper_id"
  belongs_to :dream

  validates :user, :content, presence: true
  validate :helper_actually_helped

  private

  def helper_actually_helped
    errors.add(:base, "#{helper.name} did not actually help on this dream") unless dream.connections.map(&:user).include?(helper)
  end
end
