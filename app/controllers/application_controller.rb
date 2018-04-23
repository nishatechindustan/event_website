class ApplicationController < ActionController::Base
	# with: :exception, unless: -> { request.format.json? }
  	protect_from_forgery 
   	before_action :configure_permitted_parameters, if: :devise_controller?
   	skip_before_action :verify_authenticity_token, if: :json_request?

  
	def configure_permitted_parameters
	   devise_parameter_sanitizer.permit(:account_update, keys: [:user_name,:first_name,:last_name,:location,:latitude,:longitude,:password, :password_confirmation, :current_password, :image ])
	   devise_parameter_sanitizer.permit(:sign_up, keys: [:user_name,:first_name,:last_name,:latitude,:longitude,:password, :location, :password_confirmation, :current_password, :image ])
	end

	def json_request?
    request.format.json?
  	end
end

