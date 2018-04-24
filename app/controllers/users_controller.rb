class UsersController < ApplicationController
		before_action :authenticate_user!

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
			if params[:user][:image].present?
				@user.update_attributes(image_param)
			end
			flash[:notice] =  "Profile updated successfully"
			redirect_to users_setting_path
		else
			#flash[:errors] =  @user.errors.full_messages
			flash[:notice] = @user.errors
			#{}"something went wrong"
			redirect_to users_setting_path
		end
	end

	def users_params
		params.require(:user).permit(:user_name, :first_name, :last_name, :email)
	end
	def image_param
		params.require(:user).permit(:image)
		
	end
end