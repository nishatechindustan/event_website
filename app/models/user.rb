class User < ApplicationRecord

	validates :user_name , presence: true,  length: { maximum: 50 }
	# after_initialize :check_email, :if => :new_record?
	has_many :locations,  as: :locatable , :dependent => :destroy
	has_many :events,dependent: :destroy
	has_many :attachments, as: :attachable, dependent: :destroy

	validates_uniqueness_of :email, :case_sensitive => false, :allow_blank => true, :scope=>:provider, :if => :email_changed?
	validates_format_of  :email, :with  => Devise.email_regexp, :allow_blank => true, :if => :email_changed?
	validates_presence_of  :password, :on=>:create
	validates_confirmation_of :password, :on=>:create
	validates_length_of  :password, :within => Devise.password_length, :allow_blank => true

	devise :database_authenticatable, :registerable,:confirmable,
         :recoverable, :rememberable, :trackable, :omniauthable, :omniauth_providers => [:google_oauth2,:facebook]
     #after_save :add_remove_locations

	def self.from_omniauth(auth)
		where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
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

			# if auth.provider.include?("linkedin")
			# 	user.image = auth.extra.raw_info.pictureUrls.values.last.first
			# else
			# 	user.image = auth.info.image # assuming the user model has an image
			# end
			#user.confirmed_at = Time.now()   # assuming the user model has a name
			# If you are using confirmable and the provider(s) you use validate emails,
			# uncomment the line below to skip the confirmation emails.
			# user.skip_confirmation!
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
      		#user.skip_confirmation!
		end
  	end

	# def self.from_omniauth(auth)
	# 	find_by(provider: auth['provider'], uid: auth['uid']) || create_user_from_omniauth(auth)
	# end

	# def self.create_user_from_omniauth(auth)
	# 	create(
	# 			provider: auth['provider'],
	# 			uid:      auth['uid']

	# 		)
	# end

	# def add_remove_locations
	# 	debugger
	# 	if self.locations.present?
	# 		event_loca =  Location.find_by(:locatable_id=> self.id, :locatable_type=>"User")
	# 		event_loca.update(user_location)
	# 	else
	# 	self.locations.create(user_location)
	# 	end
	# end
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

    def self.send_reset_password_instructions
      raw, enc = Devise.token_generator.generate(self.class, :reset_password_token)
	  self.reset_password_token   = enc
	  self.reset_password_sent_at = Time.now.utc
	  self.save(validate: false)
	    	
    end
    
end
