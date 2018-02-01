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
		flash[:notice] = "user deleted successfully."
		redirect_to admin_listusers_path
	else
		flash[:errors] = @user.errors.full_messages
		redirect_to admin_listusers_path
	end
  end

  private

  def get_user
	  @user = User.find params[:id]
  end
end
