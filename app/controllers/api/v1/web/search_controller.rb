module Api::V1::Web
	class SearchController < ApiController

		def search
			events = Event.search(params)
			response = {:status=>true, :total_event=>events.count, :events=>events}
			json_response(response)
		end
	end
end