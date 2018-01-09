class User < ApplicationRecord

  validates :user_name, presence: true, uniqueness: true, length: { maximum: 100 }

  has_many :locations,  as: :locatable , :dependent => :destroy
  has_many :events
  has_many :attachments, as: :attachable, dependent: :destroy
  #attr_accessor :address

  #validates :address, presence: true, on: :create
  #validates :address, presence: true, on: :update, if: :address_changed?

  #accepts_nested_attributes_for :location, :allow_destroy => true   


	devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:google_oauth2, :linkedin,:twitter,:facebook, :github]


	def self.from_omniauth(auth)
		where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
			if auth.info.email.blank?
				if auth.provider.include?("facebook")
					user.email = auth.uid + "@facebook.com"
				elsif auth.provider.include?("twitter")
					user.email = auth.uid + "@twitter.com"
				elsif auth.provider.include?("linkedin")
					user.email = auth.uid + "@linkedin.com"
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

	# def self.from_omniauth(auth)
	# 	find_by(provider: auth['provider'], uid: auth['uid']) || create_user_from_omniauth(auth)
	# end

	# def self.create_user_from_omniauth(auth)
	# 	create(
	# 			provider: auth['provider'],
	# 			uid:      auth['uid']

	# 		)
	# end

	def address_changed?
    	!address.blank?
	end
end
