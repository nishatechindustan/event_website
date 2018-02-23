class Users::RegistrationsController < Devise::RegistrationsController
   #before_action :configure_sign_in_params, only: [:create]
   #skip_before_action :verify_authenticity_token, :only => [:destroy,:create]
   prepend_before_action :require_no_authentication, :only => [:create ]

  # GET /resource/sign_in
  def new
    super
  end

  # POST /resource/sign_in
  def create

    if params[:registration][:uid].present? && params[:registration][:provider].present?
      @user = User.find_by(:uid => params[:registration][:uid])
      if @user.present?
        @user_image =  @user.attachments.present? ? @user.attachments.first.attachment.url : '';
        user_details = {:first_name=>@user.first_name,:last_name=>@user.last_name, :user_name=>@user.user_name,:auth_token=>@user.auth_token,:uid=>@user.uid,:is_admin=>@user.is_admin, :provider=> @user.provider,:image=> @user_image, :email=> @user.email }
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
            user_details = {:first_name=>@user_new.first_name,:last_name=>@user_new.last_name, :user_name=>@user_new.user_name,:auth_token=>@user_new.auth_token,:uid=>@user_new.uid,:is_admin=>@user_new.is_admin, :provider=> @user_new.provider,:image=> @user_image, :email=>@user_new.email }
          render :json=> {:status=>true , :message=>"you are sign up successfully.",:userDetails=>user_details}
        end
      end
    else
      # resource.user_location =  params[:location]
     resource = User.new(sign_up_params)
      if resource.save
      #  send_conformation_email
        # sign_in(resource)
        resource.authentication_token
        user_details = {:first_name=>resource.first_name,:last_name=>resource.last_name, :user_name=>resource.user_name,:auth_token=>resource.auth_token,:uid=>resource.uid,:is_admin=>resource.is_admin, :provider=> resource.provider, :email=> resource.email}
        render :json=> {:status=>true, :userDetails=> user_details, :message=>"Your Registration is successful. A verification code has been sent to your email. Please login and provide verification code."}
      else
        render :json=> {:status=>false, :errors=> resource.errors.full_messages}
      #resource.locations.create(user_location_params)
        # users_location = resource.locations.new(user_location_params)
        # if users_location.save
        # end
        #flash[:notice] = "user sign success"
        #redirect_to root_path
      # else
      #   flash[:errors] = resource.errors.full_messages
      #   redirect_to new_user_registration_path
      end
    end
   end
  
  def sign_up_params
    params.require(:registration).permit(:user_name, :first_name, :last_name, :email, :password, :password_confirmation, :address)
  end
  #
  #  def user_location_params
  #   params.require(:location).permit(:latitude,:longitude,:address)
  # end
  #
  # def send_conformation_email
  #   debugger
  #   UserMailer.registration_confirmation(@user).deliver
  #   # @user.update(:confirmation_token=>User.digest(@user.confirmation_token))
  # end

end
