class ApplicationController < ActionController::API
	attr_reader :current_user
	include Response
  	include ExceptionHandler

   	before_action :configure_permitted_parameters, if: :devise_controller?

	def configure_permitted_parameters
	   devise_parameter_sanitizer.permit(:account_update, keys: [:user_name,:first_name,:last_name,:location,:latitude,:longitude,:password, :password_confirmation, :current_password, :image ])
	   devise_parameter_sanitizer.permit(:sign_up, keys: [:user_name,:first_name,:last_name,:latitude,:longitude,:password, :location, :password_confirmation, :current_password, :image ])
	end

	protected
	def authenticate_request!
		unless user_id_in_token?
		render json: { errors: ['Invalid token'] }, status: :unauthorized
		return
		end
		@current_user = User.find(auth_token[:user_id])
		rescue JWT::VerificationError, JWT::DecodeError
		render json: { errors: ['Not Authenticated'] }, status: :unauthorized
	end

  	private
	def http_token
	  @http_token ||= if request.headers['Authorization'].present?
	    request.headers['Authorization'].split(' ').last
	  end
	end

	def auth_token
		@auth_token ||= JsonWebToken.decode(http_token)
	end

	def user_id_in_token?
		http_token && auth_token && auth_token[:user_id].to_i
	end
end
# class ApplicationController < ActionController::API
#   attr_reader :current_user
#   before_action :configure_permitted_parameters, if: :devise_controller?

#     protected
#     def authenticate_request!
#       unless user_id_in_token?
#         render json: { errors: ['Not Authenticated'] }, status: :unauthorized
#         return
#       end
#       @current_user = User.find(auth_token[:user_id])
#       rescue JWT::VerificationError, JWT::DecodeError
#         render json: { errors: ['Not Authenticated'] }, status: :unauthorized
#     end

#     private
#     def http_token
#         @http_token ||= if request.headers['Authorization'].present?
#           request.headers['Authorization'].split(' ').last
#         end
#     end

#     def auth_token
#       @auth_token ||= JsonWebToken.decode(http_token)
#     end

#     def user_id_in_token?
#       http_token && auth_token && auth_token[:user_id].to_i
#     end

#   def configure_permitted_parameters
#     devise_parameter_sanitizer.permit(:account_update, keys: [:user_name,:first_name,:last_name,:location,:latitude,:longitude,:password, :password_confirmation, :current_password, :image ])
#     devise_parameter_sanitizer.permit(:sign_up, keys: [:user_name,:first_name,:last_name,:latitude,:longitude,:password, :location, :password_confirmation, :current_password, :image ])
#   end
# end
