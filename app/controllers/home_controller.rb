class HomeController < ApplicationController

  def index
  	@users= User.all
  	render :json =>{:status=>true,:message=> "List of all users details",:data=> @users}
  end
end
