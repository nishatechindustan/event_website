class Users::RegistrationsController < Devise::RegistrationsController
   #before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new
    super
  end

  # POST /resource/sign_in
  def create
  # if params[:user][:address].blank?
  #   flash[:notice] = "please fill location"
  #   redirect_to new_user_registration_path and return
  # end
  super
    # resource.user_location =  params[:location]
    #resource = User.new(sign_up_params)
    if resource.save
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

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected
  # private

  # def after_sign_up_path_for(resource)
  #   users_setting_path
  # end
  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
  # def sign_up_params
  #   params.require(:user).permit(:user_name, :first_name, :last_name, :email, :password, :password_confirmation, :address)
  # end

   def user_location_params
    params.require(:location).permit(:latitude,:longitude,:address)
  end
end
