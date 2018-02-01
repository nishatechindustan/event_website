class App::Api::Admin::DashboardsController < AdminController

	before_action :get_user, only: [:delete_user]
	#skip_before_action :verify_authenticity_token#, :only => [:update]


  def index
  end

  def all_users
  	@users = User.all
    render :json =>{result: @users, status: 200}

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
