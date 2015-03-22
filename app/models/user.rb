class User < ActiveRecord::Base
  acts_as_token_authenticatable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  devise :omniauthable, :omniauth_providers => [:facebook]

  has_many :dreams

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name   # assuming the user model has a name
      user.image = auth.info.image # assuming the user model has an image
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  def self.create_user(results)
    return User.create(
      :provider => "facebook",
      :uid => results["id"],
      :email => results["email"],
      :name => results["name"],
      :image => results["picture"]["data"]["url"],
      :first_name => results["first_name"],
      :last_name => results["last_name"],
      :gender => results["gender"],
      :timezone => results["timezone"],
      :password => Devise.friendly_token[0,20]
    )
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end
