class App::Api::Web::EventsController < ApplicationController
	def today_event
		events = Event.fetch_event("today")	
		response = {:status=>true,:events=>events, :total_events=> events.count}
		json_response(response)
	end
	def paid_event
		events = Event.fetch_event("paid")	
		response = {:status=>true,:events=>events, :total_events=> events.count}
		json_response(response)
	end

	def free_event
		events = Event.fetch_event("free")	
		response = {:status=>true,:events=>events, :total_events=> events.count}
		json_response(response)
	end
end
