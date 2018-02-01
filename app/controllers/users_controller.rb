class UsersController < ApplicationController
	#before_action :authenticate_user!
	#before_action :authenticate_request!
	#skip_before_action :verify_authenticity_token
	def edit
		@user = current_user
	end

	# users profile
	def show
		@user = User.find(params[:id])
	end

	#update user
	def update
		 @user= User.find_by(auth_token: params[:auth_token])
		 if @user.present?
			 if @user.update(users_params)
			# 	if params[:user][:avatar_image].present? && avatar_image_params.present?#avatar_image_params[:attachment].present?
			# 		@user_image = 	@user.attachments.where(:attachable_id => @user.id, :attachable_type => "User")
			# 		if @user_image.present?
			# 			@user.attachments.update(avatar_image_params)
			# 		else
			# 		@user.attachments.create(avatar_image_params)
			# 		end
			# 	end
			# 	flash[:notice] =  "Profile updated successfully"
			# 	redirect_to users_setting_path
					render :json=> {:status=> true, :message=>" Profile updated successfully", :data=>@user}
			 	else
				 	render :json=> {:status=> true, :message=>@user.errors.full_messages}
				end
			else
				render :json=> {:status=> false, :message=>"Invalid token"}
			end
	end

	def destroy
		debugger
		User.find_by(:auth_token=> params[:auth_token])
		render :json=> {:status=> false, :message=>"Invalid token"}
	end


	# strong parameters for users prams
	def users_params
		params.require(:user).permit(:user_name, :first_name, :last_name, :email)
	end

	# for photo params

	def avatar_image_params
		params.require(:user).require(:avatar_image).permit(:attachment)
	end



end
