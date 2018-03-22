class CallbacksController < Devise::OmniauthCallbacksController
  def facebook
      authenticat_user(request.env["omniauth.auth"])
  end

  def google_oauth2
      authenticat_user(request.env["omniauth.auth"])
  end

  def failure
   
    render :json=> {:status=>false , :message=>"There was an error while trying to authenticate your account."}
  end

  private

  def authenticat_user(auth)
    @user = User.find_by(:uid => auth.uid)
    if @user.present?
      render :json=> {:status=>true , :message=>"you have already sign up.",:userDetails=>@user}
    else
      @user_new = User.from_omniauth(auth)
      if !@user_new.persisted?
        render :json=> {:status=>false , :message=>@user_new.errors.full_messages}
      else
        @user_attachment = @user_new.attachments.where(:attachable_id=> @user_new, :attachable_type => "User")
        if @user_attachment.present?
          @user_new.attachments.update(:attachment=>auth.info.image)
        else
         @user_new.attachments.create(:attachment=>auth.info.image)# assuming the user model has an image
        end
        render :json=> {:status=>true , :message=>"You are signup successfully.",:userDetails=>@user_new}
      end
    end
  end
end
