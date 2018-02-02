class App::Api::Admin::DashboardsController < AdminController

	before_action :get_user, only: [:delete_user]
	#skip_before_action :verify_authenticity_token#, :only => [:update]


  def index
  end

  def all_users
  	@users = User.all
    users= []
    @users.each do |user|
      @user_image =  user.attachments.present? ? user.attachments.first.attachment.url : '';
      users<<{:auth_token=>user.auth_token, :email=>user.email, :user_name => user.user_name, :first_name=> user.first_name, :last_name=> user.last_name, :is_admin => user.is_admin, :image=> @user_image}
    end

    render :json =>{result: users, status: 200}
  end

  def delete_user
	if @user.destroy
    render :json =>{:status=>true, :notice=> "User Deleted successfully", :data=>@user}
	else
		render :json => {:status=> false, :messages=> @user.errors.full_messages}
	end
  end

  private

  def get_user
	  @user = User.find params[:id]
  end
end
