class Users::PasswordsController < Devise::PasswordsController
	prepend_before_action :require_no_authentication
	
	$api = false
	def create
		if params[:user].present?
			super
		else
			resource = User.get_user(user_params_api)
			if resource.present?
				$api = true
				resource.send_reset_password_instructions
			    render :json=>{:status=>true, :message=> "Reset password send your email address.", :reset_password_token=>resource.reset_password_token}
			else
				render :json=>{:status=>false, :message=> "Email does not exit Please provide valid email address."}
			end
		end
	end

	def edit
		super
    end

	def update
		if params[:user].present?
			super
		else
			response = {:status=> false, :message=> "invalid token"}
			if params[:reset_token].present?
				if (params[:users][:password]==params[:users][:password_confirmation])
					user  = User.find_by_reset_password_token(params[:reset_token])
					if user.present?
						if user.update(password_params)
							# send_reset_password_instructions_notification(user.reset_password_token)
							response = {:status=>true, :message => "We're contacting you to notify you that your password has been changed."}
						else
							response = {:status=>false, :errors=>user.errors.full_messages}	
						end
					else
						response = {:status=>false,:message=>" Please Provide valid token"  } 
					end
				else
					response = {:status=>false, :message => "password and confirm password does not matches."}
				end
			end
			render :json=>response
		end
	end

	def user_params
	  	 # Rails.logger.info("PARAMS: #{params.inspect}")
	  	params.require(:user).require(:email) if params[:user][:email].present?
	end

	def user_params_api
	  	params.require(:email)
	end

	def password_params
		params.require(:users).permit!
	end
	def password_param
		params.require(:user).permit!
	end
 
end
