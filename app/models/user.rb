class User < ApplicationRecord

	validates :user_name , presence: true,  length: { maximum: 50 }
	has_many :locations,  as: :locatable , :dependent => :destroy
	has_many :events,dependent: :destroy
	has_many :attachments, as: :attachable, dependent: :destroy

	validates_uniqueness_of :email, :case_sensitive => false, :allow_blank => true, :scope=>:provider, :if => :email_changed?
	validates_format_of  :email, :with  => Devise.email_regexp, :allow_blank => true, :if => :email_changed?
	validates_presence_of :email , :on=>:create
	validates_presence_of  :password, :on=>:create
	validates_confirmation_of :password, :on=>:create
	validates_length_of  :password, :within => Devise.password_length, :allow_blank => true
	devise :database_authenticatable, :registerable,:confirmable,
         :recoverable, :rememberable, :trackable, :omniauthable, :omniauth_providers => [:google_oauth2,:facebook]
	before_create :set_status

	def self.from_omniauth(auth)
		where(provider: auth.provider, uid: auth.uid).first_or_create do|user|
			if auth.info.email.blank?
				if auth.provider.include?("facebook")
					user.email = auth.uid + "@facebook.com"
				elsif auth.provider.include?("google")
					user.email = auth.uid + "@google.com"
				end
			else
				user.email = auth.info.email
			end
			user.password = Devise.friendly_token[0,20]
			user.user_name = auth.info.name
			user.first_name = auth.info.first_name
			user.last_name = auth.info.last_name
		end
	end

	def self.from_socialLogin(auth)
  		where(provider: auth[:provider], uid: auth[:uid]).first_or_create do |user|
			if auth[:email].blank?
				if auth[:provider].include?("facebook")
					user.email = auth[:uid] + "@facebook.com"
				elsif auth[:provider].include?("google")
					user.email = auth[:uid] + "@google.com"
				end
			else
				user.email = auth[:email]
			end
			user.password = Devise.friendly_token[0,20]
			user.user_name = auth[:user_name]
			user.first_name = auth[:first_name]
			user.last_name = auth[:last_name]
			user.auth_token = auth[:auth_token]
			user.status = true
		end
	end

	def address_changed?
    	!address.blank?
	end

  def authentication_token
  	auth_token= SecureRandom.urlsafe_base64
    self.update_columns(auth_token: auth_token)
  end

  def self.digest(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def self.changeStatus(user)
  	if user.status==true
  		user.update(:status=>false)
  		message = "User has been Deactivate successfully"
  	else
  		user.update(:status=>true)
  		message = "User has been Activate successfully"
  	end

  	return {:status=>true, :message=>message}
  end

  def set_status
  	self.status = true
  end
end
