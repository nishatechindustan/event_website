class HomeController < ApplicationController

  def index
  	# @users= User.all
  	# render :json =>{:status=>true,:message=> "List of all users details",:data=> @users}
  	response = RestClient::Request.execute(
		method: :get,
		url: 'https://eventwesite.herokuapp.com/api/v1/web/recent_event')
		result = JSON.parse(response.body)
		@recent_event = result["events"]
  end
end
