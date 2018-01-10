class CallbacksController < Devise::OmniauthCallbacksController


  def facebook
      authenticat_user(request.env["omniauth.auth"])
  end

  def google_oauth2
      authenticat_user(request.env["omniauth.auth"])
  end

  # def twitter
  # 	authenticat_user(request.env["omniauth.auth"])
  # end

  # def linkedin
  #   authenticat_user(request.env["omniauth.auth"])
  # end

  def failure
    #Could not authenticate you from Facebook because "Permissions error".
    flash[:alert] = "There was an error while trying to authenticate your account."
    redirect_to root_path and return
  end

  # def github
  #   authenticat_user(request.env["omniauth.auth"])
  # end

  private

  def authenticat_user(auth)
    @user = User.find_by(:uid => auth.uid)
    if @user.present?
      sign_in(@user)
      flash[:notice] = "you have already sign up."
      redirect_to(user_profile_path(@user)) and return
    else
      @user_new = User.from_omniauth(auth)

      if !@user_new.persisted?
        flash[:errors] = @user_new.errors.full_messages
        redirect_to root_path
      else
        @user_attachment = @user_new.attachments.where(:attachable_id=> @user_new, :attachable_type => "User")
        if @user_attachment.present?
          @user_new.attachments.update(:attachment=>auth.info.image)
        else
         @user_new.attachments.create(:attachment=>auth.info.image)# assuming the user model has an image
        end

        if @user_new.email.include?("facebook") || @user_new.email.include?("twitter") || @user_new.email.include?("linkedin")
          flash[:notice] = 'Please update email address'
        end 

        sign_in(@user_new)
        
        if @user_new.sign_in_count==1
           redirect_to(users_setting_path) and return
        else
          redirect_to(user_profile_path(@user_new)) and return
        end
      end
    end
  end
end	
