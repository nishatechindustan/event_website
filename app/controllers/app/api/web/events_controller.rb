class App::Api::Web::EventsController < ApplicationController
  	before_action :get_event_id ,only:[:event_details]
  	before_action :get_event_data ,only:[:event_details]

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

	def recent_event
		events = Event.fetch_event('')	
		response = {:status=>true,:events=>events, :total_events=> events.count}
		json_response(response)
	end
	def event_details

		@event_image = @event.attachments.present? ? @event.attachments.first.attachment.url : '/default_image.jpg';
		@event_currency = @event.currency.present? ? @event.currency: ''
		event_date_time = {:start_date=>@event_dates.start_date,:end_date=>@event_dates.end_date ,:start_time=>@event_dates.start_time,:end_time=>@event_dates.end_time}
		event_location= {:address=>@event_location.address,:latitude=>@event_location.latitude,:longitude=>@event_location.longitude,:venue=>@event_location.venue,:locality=> @event_location.city,:administrative_area_level_1=>@event_location.state,:country=>@event_location.country}

		event = {:event_categories=>@event_categories.map(&:id), :event_location=>event_location,
		  :event_artists=>@event_artists.map(&:id),:event_date=>event_date_time,:event=>@event, :event_image=>@event_image}
		 response ={:status=>true, :event=>event}
		    
		json_response(response)
	end

	private

	def get_event_id
    	@event = Event.find params[:id]
  	end

  	def get_event_data
	    @event_categories =  @event.categories
	    @event_artists =  @event.artists
	    @event_location = @event.locations.first
	    @event_dates = @event.event_adver_dates.first
  	end
end
