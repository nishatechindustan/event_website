class HomeController < ApplicationController
	#before_action :authenticate_user!
	    # include ActionView::Helpers::TextHelper
	def index
		@events = Event.fetch_event('')
		Rails.logger.info("PARAMS: #{@events}")
		Rails.logger.info("-------------------------------------------------------")
		@states = State.all.order("name ASC").map(&:name)
		@categories = Category.all.order("name ASC").map{|a| [a.name, a.id]}
		# @users= User.all? { |e|  }
		# render :json =>{:status=>true,:message=> "List of all users details",:data=> @users}
		# response = RestClient::Request.execute(
		# method: :get,
		# url: 'https://eventwesite.herokuapp.com/api/v1/web/recent_event')
		# result = JSON.parse(response.body)
		# @recent_event = result["events"]
	end
end
