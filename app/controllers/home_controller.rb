class HomeController < ApplicationController
	#before_action :authenticate_user!
	def index
		@events = Event.fetch_event('')
		Rails.logger.info("PARAMS: #{@events}")
		Rails.logger.info("-------------------------------------------------------")
		byebug
		# @users= User.all
		# render :json =>{:status=>true,:message=> "List of all users details",:data=> @users}
		# response = RestClient::Request.execute(
		# method: :get,
		# url: 'https://eventwesite.herokuapp.com/api/v1/web/recent_event')
		# result = JSON.parse(response.body)
		# @recent_event = result["events"]
	end
end
