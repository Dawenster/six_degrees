class User < ActiveRecord::Base
  acts_as_token_authenticatable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  devise :omniauthable, :omniauth_providers => [:facebook]

  has_many :dreams
  has_many :connections

  s3_credentials_hash = {
    :access_key_id => ENV['AWS_ACCESS_KEY'],
    :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
  }

  has_attached_file :avatar, 
                    :styles => { :small => "40x40#", :large => "200x200#" },
                    :s3_credentials => s3_credentials_hash,
                    :bucket => ENV['AWS_BUCKET'],
                    :default_url => "https://s3-us-west-2.amazonaws.com/six-degrees-app/general/no_profile.png",
                    :s3_protocol => :https

  validates_attachment_content_type :avatar, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name   # assuming the user model has a name
      user.first_name = auth.info.first_name
      user.last_name = auth.info.last_name
      user.image = auth.info.image # assuming the user model has an image
      user.skip_confirmation!
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

  def connections_received
    self.dreams.map{|d| d.connections}.flatten
  end

  def num_connections_received
    num = self.connections_received.count
    return num == 0 ? nil : num
  end

  def dreams_with_connections
    self.dreams.select{|d| d.connections.any?}
  end
end
