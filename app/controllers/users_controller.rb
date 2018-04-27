class UsersController < ApplicationController
		#before_action :authenticate_user!

	def edit
		#@user = User.find_by(:id => params[:user_id])
		@user = current_user
	end

	# users profile
	def show
		@user = User.find(params[:id])
		
	end

	#update user
	def update
		#user = User.find_by(:id=> params[:user_id])
		@user = current_user
		if @user.update(users_params)
			if params[:user][:avatar_image].present? && avatar_image_params.present?
				@user_image = @user.attachments.where(:attachable_id => @user.id, :attachable_type => "User")
				if @user_image.present?
					@user.attachments.update(avatar_image_params)
				else
					@user.attachments.create(avatar_image_params)
				end
			end
			flash[:notice] =  "Profile updated successfully"
			redirect_to users_setting_path
		else
			flash[:errors] =  @user.errors.full_messages
			# flash[:notice] = @user.errors
			#{}"something went wrong"
			redirect_to users_setting_path
		end
	end

	def users_params
		params.require(:user).permit(:user_name, :first_name, :last_name, :email)
	end
	def avatar_image_params
		params.require(:user).require(:avatar_image).permit(:attachment)
		
	end
end