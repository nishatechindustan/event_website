class Api::v1::Web::SearchController < ApplicationController

	def search
		events = Event.search(params)
		response = {:status=>true, :total_event=>events.count, :events=>events}
		json_response(response)
	end
end
