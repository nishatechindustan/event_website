class Users::SessionsController < Devise::SessionsController
#  skip_before_action :verify_authenticity_token, :only => [:destroy,:create]
  prepend_before_action :require_no_authentication, :only => [:create ]
  #skip_before_action :verify_authenticity_token, :only => [:create]
  before_action :ensure_params_exist, :only =>[:create]

  #respond_to :json

  def create
    # resource = User.find_for_database_authentication(:email => params[:email])
    if params[:session].present?
      resource = User.find_by(:email => params[:email], :provider=>nil)
      return invalid_login_attempt unless resource
      
      if resource.valid_password?(params[:password])
          userDetails= payload(resource)
        # resource.authentication_token
        # userDetails = {:auth_token=>auth_token, :email=>resource.email, :user_name => resource.user_name, :first_name=> resource.first_name, :last_name=> resource.last_name, :is_admin => resource.is_admin,:status=>resource.status, :image=> @user_image}
        render :json=> {:status=>true, :userDetails=>userDetails, :message=> "You logged in"}
        return
      end
      invalid_login_attempt
    else
      super
     end
  end

  protected

  def ensure_params_exist
    if !params[:session].present?
      params.require(:user).permit(:email,:password, :remember_me)
    else
      return unless params[:email].blank? || params[:password].blank?
      render :json=>{:status=>false, :message=>"missing user_login parameter"}, :status=>false
    end
  end



  def invalid_login_attempt
    warden.custom_failure!
    render :json=> {:status=>false, :message=>"Invalid Username / Password"}, :status=>false
  end

  def payload(user)
    return nil unless user and user.id
    {
      auth_token: JsonWebToken.encode({user_id: user.id}),image: user.attachments.present? ? user.attachments.first.attachment.url : '/default_image.jpg',
      email: user.email, user_name: user.user_name, first_name: user.first_name, last_name: user.last_name, is_admin: user.is_admin, status: user.status
      #  :email=>user.email, :user_name => user.user_name, :first_name=> user.first_name, :last_name=> user.last_name, :is_admin => user.is_admin,:status=>user.status, :image=> @user_image}
      # # auth_token: JsonWebToken.encode({user_id: user.id})
    }
  end
end
