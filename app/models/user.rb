class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
	validates :user_name , presence: true,  length: { maximum: 50 }
	has_many :locations,  as: :locatable , :dependent => :destroy
	has_many :events,dependent: :destroy
	has_many :attachments, as: :attachable, dependent: :destroy

	devise :database_authenticatable, :registerable,:timeoutable,
         :recoverable,:validatable, :rememberable, :trackable, :omniauthable, :omniauth_providers => [:google_oauth2,:facebook]
	before_create :set_status

    #after_create :subscribe_user_to_newslatter


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
			user.skip_confirmation!
		end
	end

	def address_changed?
    	!address.blank?
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

  def subscribe_user_to_newslatter
	SubscribeUserToMailingListJob.perform_later(self)
  end

  def self.get_user(email)
  	find_by(:email=> email, :provider=>nil)
  end
end
