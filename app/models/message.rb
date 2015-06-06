class Message < ActiveRecord::Base
  belongs_to :user, :class_name => 'User', :foreign_key => 'user_id'
  belongs_to :recipient, :class_name => 'User', :foreign_key => 'recipient_id'

  belongs_to :dream
end
