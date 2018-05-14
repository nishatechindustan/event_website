class EventsController < ApplicationController

	def today_event
		@events = Event.fetch_event("today")
	end

	def paid_event
		@events = Event.fetch_event("paid")
	end
end
