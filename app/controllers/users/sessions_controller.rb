class Users::SessionsController < Devise::SessionsController
#  skip_before_action :verify_authenticity_token, :only => [:destroy,:create]
  prepend_before_action :require_no_authentication, :only => [:create ]

  before_action :ensure_params_exist, :only =>[:create]

  respond_to :json

  def create
    # resource = User.find_for_database_authentication(:email => params[:email])
    resource = User.find_by(:email => params[:email], :provider=>nil)
    return invalid_login_attempt unless resource
    
    if resource.valid_password?(params[:password])
      @user_image =  resource.attachments.present? ? resource.attachments.first.attachment.url : '';
      resource.authentication_token
      userDetails = {:auth_token=>resource.auth_token, :email=>resource.email, :user_name => resource.user_name, :first_name=> resource.first_name, :last_name=> resource.last_name, :is_admin => resource.is_admin, :image=> @user_image}
      render :json=> {:status=>true, :userDetails=>userDetails, :message=> "Successfully Login"}
      return
    end
    invalid_login_attempt
  end

  protected

  def ensure_params_exist
    return unless params[:email].blank? || params[:password].blank?
    render :json=>{:status=>false, :message=>"missing user_login parameter"}, :status=>false
  end



  def invalid_login_attempt
    warden.custom_failure!
    render :json=> {:status=>false, :message=>"Error with your login or password"}, :status=>false
  end
end
