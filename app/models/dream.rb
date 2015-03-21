class Dream < ActiveRecord::Base
  belongs_to :user

  validates :description, :dream_type, :user_id, :presence => true, allow_blank: false

  def self.dreams_with_user_info
    dreams = []
    Dream.all.each do |dream|
      dreams << {
        :user => dream.user,
        :content => dream
      }.as_json
    end
    return dreams
  end
end
