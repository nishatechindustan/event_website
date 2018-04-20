class ApplicationController < ActionController::Base
	
  	protect_from_forgery with: :exception, unless: -> { request.format.json? }
   	before_action :configure_permitted_parameters, if: :devise_controller?

	def configure_permitted_parameters
	   devise_parameter_sanitizer.permit(:account_update, keys: [:user_name,:first_name,:last_name,:location,:latitude,:longitude,:password, :password_confirmation, :current_password, :image ])
	   devise_parameter_sanitizer.permit(:sign_up, keys: [:user_name,:first_name,:last_name,:latitude,:longitude,:password, :location, :password_confirmation, :current_password, :image ])
	end
end

