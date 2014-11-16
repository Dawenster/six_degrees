class Dream < ActiveRecord::Base
  belongs_to :user

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
