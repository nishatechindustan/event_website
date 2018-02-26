class Users::PasswordsController < Devise::PasswordsController
	prepend_before_action :require_no_authentication
	# append_before_action :assert_reset_token_passed, only: :edit


	def create
	    resource = User.find_by_email(user_params)
		if resource.present?
		    resource = resource.send_reset_password_instructions
		    render :json=>{:status=>true, :message=> "Reset password send your email address.", :reset_password_token=>resource}
		else
			render :json=>{:status=>false, :message=> "Email does not exits."}
		end
	end

	def update

	end

	def user_params
	  	params.require(:email)
	end

	def password_params
		params.require(:users).permit!
		
	end
 
end
