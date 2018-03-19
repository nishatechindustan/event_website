class HomeController < ApplicationController
	#before_action :authenticate_user!
  def index
  	@users= User.all

  	render :json =>{:status=>true,:message=> "List of all users details",:data=> @users}
  end
end
