module ApplicationHelper
  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def resource_class
    devise_mapping.to
  end

  def errors_for(model, attribute)
    if model.errors[attribute].present?
      content_tag :span, :class => 'error_explanation' do
        model.errors[attribute].join(", ").capitalize
      end
    end
  end

  def avatar(user)
    if user.uid
      image_tag "https://graph.facebook.com/#{user.uid}/picture", :class => "user-avatar"
    else
      image_tag user.avatar.url(:small), :class => "user-avatar"
    end
  end

  def profile_picture(user)
    if user.uid
      image_tag "https://graph.facebook.com/#{user.uid}/picture?width=350&height=350", :class => "user-profile-picture"
    else
      image_tag user.avatar.url(:large), :class => "user-profile-picture"
    end
  end

  def pending_received_activities(dreams)
    count = dreams.map{|r|r.connections}.flatten.select{|r|r.accepted == nil}.count
    count == 0 ? nil : count
  end

  def current_user_profile_page(user)
    user_signed_in? && user == current_user
  end

  def school_name
    "Kellogg"
  end
end
