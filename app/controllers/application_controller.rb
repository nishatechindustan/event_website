class ApplicationController < ActionController::Base
	# with: :exception, unless: -> { request.format.json? }
	protect_from_forgery 
	before_action :configure_permitted_parameters, if: :devise_controller?
	skip_before_action :verify_authenticity_token, if: :json_request?
	before_action :check_email, if: :user_signed_in?

  
	def configure_permitted_parameters
	   devise_parameter_sanitizer.permit(:account_update, keys: [:user_name,:first_name,:last_name,:location,:latitude,:longitude,:password, :password_confirmation, :current_password, :image ])
	   devise_parameter_sanitizer.permit(:sign_up, keys: [:user_name,:first_name,:last_name,:latitude,:longitude,:password, :location, :password_confirmation, :current_password, :image ])
	end

	def json_request?
    	request.format.json?
	end

	private

  def after_sign_out_path_for(resource_or_scope)
    root_path
  end

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
end

