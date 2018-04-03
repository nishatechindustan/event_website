class Users::RegistrationsController < Devise::RegistrationsController
   prepend_before_action :require_no_authentication, :only => [:create ]

  # GET /resource/sign_in
  def new
    super
  end

  # POST /resource/sign_in
  def create
    uid =  params[:registration][:uid].present? && params[:registration][:provider].present? if params[:registration]
    if (uid) 
      @user = User.find_by(:uid => params[:registration][:uid])
      if @user.present?
        @user_image =  @user.attachments.present? ? @user.attachments.first.attachment.url : '';
        user_details = {:first_name=>@user.first_name,:last_name=>@user.last_name, :user_name=>@user.user_name,:auth_token=>@user.auth_token,:uid=>@user.uid,:is_admin=>@user.is_admin, :provider=> @user.provider,:image=> @user_image, :email=> @user.email, :status=>@user.status}
        render :json=> {:status=>true , :message=>"you are sign up successfully.",:userDetails=> user_details}

      else
        @user_new = User.from_socialLogin(params[:registration])
        if !@user_new.persisted?

          render :json=> {:status=>false , :errors=>@user_new.errors.full_messages}
        else
          @user_attachment = @user_new.attachments.where(:attachable_id=> @user_new, :attachable_type => "User")
          if @user_attachment.present?
            @user_new.attachments.update(:attachment=>params[:image])
          else
           @user_new.attachments.create(:attachment=>params[:image])# assuming the user model has an image
          end
            @user_image =  @user_new.attachments.present? ? @user_new.attachments.first.attachment.url : '';
          if @user_new.email.include?("facebook") || @user_new.email.include?("twitter") || @user_new.email.include?("linkedin")
          end
            user_details = {:first_name=>@user_new.first_name,:last_name=>@user_new.last_name, :user_name=>@user_new.user_name,:auth_token=>@user_new.auth_token,:uid=>@user_new.uid,:is_admin=>@user_new.is_admin, :provider=> @user_new.provider,:image=> @user_image, :email=>@user_new.email, :status=>@user_new.status}
          render :json=> {:status=>true , :message=>"you are sign up successfully.",:userDetails=>user_details}
        end
      end
    else
      resource = User.new(sign_up_params)
      resource.skip_confirmation!
      if resource.save
        resource.authentication_token
        user_details = {:first_name=>resource.first_name,:last_name=>resource.last_name, :user_name=>resource.user_name,:auth_token=>resource.auth_token,:uid=>resource.uid,:is_admin=>resource.is_admin, :provider=> resource.provider, :email=> resource.email, :status=>resource.status}
        render :json=> {:status=>true, :userDetails=> user_details, :message=>"Your Registration is successful. A verification code has been sent to your email. Please login and provide verification code."}
      else
        render :json=> {:status=>false, :errors=> resource.errors.full_messages}
      end
    end
   end
  
  def sign_up_params
    if params[:registration]
      params.require(:registration).permit(:user_name, :first_name, :last_name, :email, :password, :password_confirmation, :address) 
    #  params.fetch(:registration, {}).permit(:user_name, :first_name, :last_name, :email, :password, :password_confirmation)
    else
      user_sign_up ={
        user_name: params.fetch(:user_name,''),
        email: params.fetch(:email,''),
        password: params.fetch(:password,''),
        password_confirmation: params.fetch(:password_confirmation,''),
        first_name: params.fetch(:first_name,''),
        last_name: params.fetch(:last_name, '')
      }
    end
  end
end
