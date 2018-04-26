class CallbacksController < Devise::OmniauthCallbacksController
  def facebook
      authenticat_user(request.env["omniauth.auth"])
  end

  def google_oauth2
      authenticat_user(request.env["omniauth.auth"])
  end

  def failure
    flash[:alert] = "There was an error while trying to authenticate your account."
    redirect_to new_user_registration_path
  end

  private

  def authenticat_user(auth)

    @user_new = User.from_omniauth(auth)
      if !@user_new.persisted?
          flash[:errors] = @user_new.errors.full_messages
          redirect_to root_path
        else

          if  @user_new.email.include?("facebook") || @user_new.email.include?("twitter") || @user_new.email.include?("linkedin")
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
