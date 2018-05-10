class EventsController < ApplicationController

	def today_event
		@events = Event.fetch_event("today")
	end
end
