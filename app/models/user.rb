class User < ActiveRecord::Base
  acts_as_token_authenticatable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :async
  devise :omniauthable, :omniauth_providers => [:facebook]

  has_many :dreams, :dependent => :destroy
  has_many :messages, :class_name => 'Message', :foreign_key => 'user_id', :dependent => :destroy
  has_many :received_messages, :class_name => 'Message', :foreign_key => 'recipient_id', :dependent => :destroy
  has_many :connections, :dependent => :destroy
  has_many :hearts, :dependent => :destroy
  has_many :referrals
  belongs_to :referred_by, :class_name => "User", :foreign_key => "referred_by_user_id"
  has_many :successful_referrals, :class_name => "User", :foreign_key => "referred_by_user_id"
  has_many :given_kudos, :class_name => "Kudo", :foreign_key => "giver_id"
  has_many :received_kudos, :class_name => "Kudo", :foreign_key => "receiver_id"

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
  validates :first_name, :last_name, :presence => true, allow_blank: false
  validate :kellogg_email, on: :create

  before_save :ensure_authentication_token
  before_create :check_if_referred

  KELLOGG_DOMAIN = "@kellogg.northwestern.edu"

  def to_param
    "#{id}-#{first_name.parameterize.downcase}-#{last_name.parameterize.downcase}"
  end

  def self.from_omniauth(auth)
    user = where(provider: auth.provider, uid: auth.uid).first_or_initialize do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name   # assuming the user model has a name
      user.first_name = auth.info.first_name
      user.last_name = auth.info.last_name
      user.gender = auth.extra.raw_info.gender
      user.skip_confirmation!
    end
    user.save(:validate => false)
    return user
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
      # :name => results["name"],
      # :image => results["picture"]["data"]["url"],
      :first_name => results["first_name"],
      :last_name => results["last_name"],
      :gender => results["gender"],
      :timezone => results["timezone"],
      :password => Devise.friendly_token[0,20]
    )
  end

  def name
    # For rails admin to pick up names
    full_name
  end

  def full_name
    name = "#{first_name} #{last_name}"
    if name.length > 16
      return first_name
    else
      return name
    end
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
 
  def ensure_authentication_token
    if authentication_token.blank? && !authentication_token_changed?
      self.authentication_token = generate_authentication_token
    end
  end

  def owner_of?(dream)
    return dream.user == self
  end

  def small_avatar
    if self.uid.present?
      return "https://graph.facebook.com/#{self.uid}/picture"
    elsif self.avatar.url.present?
      return self.avatar.url(:small)
    else
      return "https://s3-us-west-2.amazonaws.com/six-degrees-app/general/no_profile.png"
    end
  end

  def large_avatar
    if self.uid.present?
      return "https://graph.facebook.com/#{self.uid}/picture?width=350&height=350"
    elsif self.avatar.url.present?
      return self.avatar.url(:large)
    else
      return "https://s3-us-west-2.amazonaws.com/six-degrees-app/general/no_profile.png"
    end
  end

  def already_hearted?(dream)
    dream.hearts.where(user_id: id).any?
  end

  def heart_for_dream(dream)
    hearts.where(dream_id: dream.id).first
  end

  def already_kudos_user?(user)
    given_kudos.where(receiver_id: user.id).any?
  end
 
  private
  
  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end

  def check_if_referred
    referral = Referral.find_by_email(email)
    self.referred_by_user_id = referral.user.id if referral.present? && referral.user.present?
  end

  def kellogg_email
    email_domain = email.split("@").last
    errors.add(:email, "must end in #{KELLOGG_DOMAIN}") if email_domain != KELLOGG_DOMAIN
  end
end
