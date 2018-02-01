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
    # data={}
  # if params[:user][:address].blank?
  #   flash[:notice] = "please fill location"
  #   redirect_to new_user_registration_path and return
  # end
  #super
    # resource = User.new(sign_up_params)
    if params[:registration][:uid].present? && params[:registration][:provider].present?
      @user = User.find_by(:uid => params[:registration][:uid])
      if @user.present?
        @user_image =  @user.attachments.present? ? @user.attachments.first.attachment.url : '';
        user_details = {:first_name=>@user.first_name,:last_name=>@user.last_name, :user_name=>@user.user_name,:auth_token=>@user.auth_token,:uid=>@user.uid,:is_admin=>@user.is_admin, :provider=> @user.provider,:image=> @user_image, :email=> @user.email }
        #  sign_in(@user)
        # flash[:notice] = "you have already sign up."
        #redirect_to(user_profile_path(@user)) and return
        # data ={:userDetails=> @user, :image=> @user_image}
        render :json=> {:status=>true , :message=>"you are sign up successfully.",:userDetails=> user_details}
        # redirect_to(users_setting_path) and return
    #  elsif condition

      else
        @user_new = User.from_socialLogin(params[:registration])
        if !@user_new.persisted?
          # flash[:errors] = @user_new.errors.full_messages
          # redirect_to root_path
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
            # flash[:notice] = 'Please update email address'
          end
            user_details = {:first_name=>@user_new.first_name,:last_name=>@user_new.last_name, :user_name=>@user_new.user_name,:auth_token=>@user_new.auth_token,:uid=>@user_new.uid,:is_admin=>@user_new.is_admin, :provider=> @user_new.provider,:image=> @user_image, :email=>@user_new.email }
          #sign_in(@user_new)
          # data = {:userDetails=> @user_new, :image=> @user_image}
          render :json=> {:status=>true , :message=>"you are sign up successfully.",:userDetails=>user_details}
          #
          # if @user_new.sign_in_count==1
          #    redirect_to(users_setting_path) and return
          # else
          #   redirect_to(users_setting_path) and return
          #   #redirect_to(user_profile_path(@user_new)) and return
          # end
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
      #sign_in(@user_new)
        # return  render :status=>"true", :json=> {:message=> "sign in successfully", :user=> resource}#,:location => after_sign_up_path_for(resource)
        render :json=> {:status=>true, :userDetails=> user_details}
      else
        #clean_up_passwords resource
        #return render :status=>"false", :json=> {:errors=> resource.errors.full_messages}
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
  #
  # # DELETE /resource/sign_out
  # # def destroy
  # #   super
  # # end
  #
  # # protected
  # # private
  #
  # # def after_sign_up_path_for(resource)
  # #   users_setting_path
  # # end
  # # If you have extra params to permit, append them to the sanitizer.
  # # def configure_sign_in_params
  # #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # # end
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
