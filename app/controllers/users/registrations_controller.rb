class Users::RegistrationsController < Devise::RegistrationsController
   prepend_before_action :require_no_authentication, :only => [:create ]
   #skip_before_action :verify_authenticity_token, :only => [:create]

   #before_action :check_request_type , only:[:create]
  # GET /resource/sign_in
  def new
    super
  end

  # POST /resource/sign_in
  # def create
  #   uid =  params[:registration][:uid].present? && params[:registration][:provider].present? if params[:registration]
  #   if (uid) 
  #     @user = User.find_by(:uid => params[:registration][:uid])
  #     if @user.present?
  #       user_details= payload(@user)
  #       render :json=> {:status=>true , :message=>"you are sign up successfully.",:userDetails=> user_details}

  #     else
  #       @user_new = User.from_socialLogin(params[:registration])
  #       if !@user_new.persisted?

  #         render :json=> {:status=>false , :errors=>@user_new.errors.full_messages}
  #       else
  #         @user_attachment = @user_new.attachments.where(:attachable_id=> @user_new, :attachable_type => "User")
  #         if @user_attachment.present?
  #           @user_new.attachments.update(:attachment=>params[:image])
  #         else
  #          @user_new.attachments.create(:attachment=>params[:image])# assuming the user model has an image
  #         end
  #           user_details= payload(@user_new)
  #         render :json=> {:status=>true , :message=>"you are sign up successfully.",:userDetails=>user_details}
  #       end
  #     end
  #   else
  #     resource = User.new(sign_up_params1)
  #     if resource.save
  #       user_details= payload(resource)
  #       render :json=> {:status=>true, :userDetails=> user_details, :message=>"Your Registration is successful. A verification code has been sent to your email. Please login and provide verification code."}
  #     else
  #       render :json=> {:status=>false, :errors=> resource.errors.full_messages}
  #     end
  #   end
  # end

  # def edit
  #   @user|| = @current_user
  #   @user_image =  @user.attachments.present? ? @user.attachments.first.attachment.url : '/default_image.jpg';
  #   user = {:id=>@user.id, :email=>@user.email, :user_name => @user.user_name, :first_name=> @user.first_name, :last_name=> @user.last_name, :is_admin => @user.is_admin, :image=> @user_image}
  #   render :json =>{data: user, status: true}
  # end 
  def create
    if !params[:user].present? 
       resource = User.new(sign_up_params1)
      if resource.save
        user_details= payload(resource)
        render :json=> {:status=>true, :userDetails=> user_details, :message=>"Your Registration is successful. A verification code has been sent to your email. Please login and provide verification code."}
      else
        render :json=> {:status=>false, :errors=> resource.errors.full_messages}
      end
    else
      @user = User.new(sign_up_params)
      if @user.save
         flash[:notice] = "Your Registration is successful. A verification code has been sent to your email. Please login and provide verification code."
        # redirect_to root_url
        sign_in(@user)
      else
        render :action => :new
      end
    end
  end
  def sign_up_params1
    if params[:registration]
      params.require(:registration).permit(:user_name, :first_name, :last_name, :email, :password, :password_confirmation, :address) 
   
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

  def sign_up_params
   params.require(:user).permit(:user_name, :first_name, :last_name, :email, :password, :password_confirmation, :address)
  end

  def payload(user)
    return nil unless user and user.id
    {
      auth_token: JsonWebToken.encode({user_id: user.id}),image: user.attachments.present? ? user.attachments.first.attachment.url : '/default_image.jpg',
      email: user.email, user_name: user.user_name, first_name: user.first_name, last_name: user.last_name, :uid=>user.uid, is_admin: user.is_admin, status: user.status,:provider=> user.provider
    }
  end
end
