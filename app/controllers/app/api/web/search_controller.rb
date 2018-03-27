class App::Api::Web::SearchController < ApplicationController

	def search
		events = Event.search(params)
		# @events = {:status=>true, :}
		response = {:status=>true, :total_event=>events.count, :events=>events }
		json_response(response)
	end
end
