class App::Api::Admin::UsersController < AdminController
	#before_action :authenticate_user!
	#before_action :authenticate_request!
	#skip_before_action :verify_authenticity_token
	before_action :get_user, only: [:delete_user]

	def all_users
	  	current_user = User.find_by_auth_token(params[:auth_token])
	    @users = User.all - [current_user]
	    users= []
	    @users.each do |user|
	      @user_image =  user.attachments.present? ? user.attachments.first.attachment.url : '';
	      users<<{:auth_token=>user.auth_token, :id=>user.id, :email=>user.email, :user_name => user.user_name, :first_name=> user.first_name, :last_name=> user.last_name, :is_admin => user.is_admin, :image=> @user_image}
	    end
	    render :json =>{result: users, status: 200}
  	end

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
				if params[:user][:attachment].present? && avatar_image_params.present?
					@user_image = @user.attachments.where(:attachable_id => @user.id, :attachable_type => "User")
					if @user_image.present?
						@user.attachments.update(avatar_image_params)
					else
						@user.attachments.create(avatar_image_params)
					end
				end
			@user_image =  @user.attachments.present? ? @user.attachments.first.attachment.url : '';
			userDetails = {:auth_token=>@user.auth_token, :email=>@user.email, :user_name => @user.user_name, :first_name=> @user.first_name, :last_name=> @user.last_name, :is_admin => @user.is_admin, :image=> @user_image}
			render :json=> {:status=> true, :message=>" Profile updated successfully", :userDetails=>userDetails}
		 	else
			 	render :json=> {:status=> true, :message=>@user.errors.full_messages}
			end
		else
			render :json=> {:status=> false, :message=>"Invalid token"}
		end
	end

	def delete_user
		if @user.destroy
			render :json =>{:status=>true, :notice=> "User Deleted successfully", :data=>@user}
		else
			render :json => {:status=> false, :messages=> @user.errors.full_messages}
		end
  	end


	# strong parameters for users prams
	def users_params
		params.require(:user).permit(:user_name, :first_name, :last_name, :email)
	end

	# for photo params

	def avatar_image_params
		params.require(:user).require(:attachment).permit(:attachment)
	end

	private

	def get_user
	  @user = User.find params[:id]
	end


end
