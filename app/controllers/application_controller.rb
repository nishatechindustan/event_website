class ApplicationController < ActionController::API
#  protect_from_forgery with: :exception
#protect_from_forgery with: :null_session

   before_action :check_email, if: :user_signed_in?
  #before_action :authenticate_user!
   before_action :configure_permitted_parameters, if: :devise_controller?
   #before_action :cors_set_access_control_headers

  def check_email
    if !current_user.is_admin? && current_user.uid.present?
      if params[:controller]!="users"
        if params[:controller]=="devise/sessions"
          return
        end

        if current_user.email.include?(current_user.uid)
           flash[:notice]="Please update email address"
           redirect_to users_setting_path and return
      	elsif params[:action] != "edit" && params[:action] != "update"
	        if current_user.email.include?("facebook") || current_user.email.include?("twitter") || current_user.email.include?("linkedin")
            flash[:notice]="Please update email address"
            redirect_to users_setting_path and return
	        end
        end
      end
    end
  end


	def configure_permitted_parameters
	     devise_parameter_sanitizer.permit(:account_update, keys: [:user_name,:first_name,:last_name,:location,:latitude,:longitude,:password, :password_confirmation, :current_password, :image ])
	     devise_parameter_sanitizer.permit(:sign_up, keys: [:user_name,:first_name,:last_name,:latitude,:longitude,:password, :location, :password_confirmation, :current_password, :image ])
	end

  # def authenticate_user
	# 	 user = User.find_by(email: params[:email])
	#   if user && user.authenticate(params[:password])
	# 	render json: payload(user)
	# 	else
	# 	render json: {errors: ['Invalid Username/Password']}, status: :unauthorized
	# 	end
	# end
  #
  # protected
	# def authenticate_request!
	# 	unless user_id_in_token?
	# 	render json: { errors: ['Not Authenticated'] }, status: :unauthorized
	# 	return
	# 	end
	# 	@current_user = User.find(auth_token[:user_id])
	# 	rescue JWT::VerificationError, JWT::DecodeError
	# 	render json: { errors: ['Not Authenticated'] }, status: :unauthorized
	# end
  #
  # 	private
  # 	def http_token
	# 	@http_token ||= if request.headers['Authorization'].present?
	# 		request.headers['Authorization'].split(' ').last
  #  		 end
  # 	end
  #
  # 	def auth_token
  #   	@auth_token ||= JsonWebToken.decode(http_token)
  # 	end
  #
  # 	def user_id_in_token?
  # 	  http_token && auth_token && auth_token[:user_id].to_i
  # 	end
  #
  # 	def payload(user)
  #   return nil unless user and user.id
  #   {
  #
  #     auth_token: JsonWebToken.encode({user_id: user.id}),
  #     user: {id: user.id, email: user.email}
  #   }
  # end

end
