module MessageHelper
  def response_tip_placeholder(user)
    "How can you help #{user.first_name}?"
  end

  def user_credentials_placeholder(user)
    "What makes you qualified to help #{user.first_name}?"
  end
end
