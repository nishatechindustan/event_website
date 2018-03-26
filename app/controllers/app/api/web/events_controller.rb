class App::Api::Web::EventsController < ApplicationController
	def today_event
		events = Event.fetch_event	
		response = {:message=>true,:status=>true,:events=>events}
		json_response(response)
	end
	def paid_event
		
	end
end
