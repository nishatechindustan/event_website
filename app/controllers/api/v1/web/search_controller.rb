module Api::V1::Web
	class SearchController < ApiController

		def search
			@events = Event.search(params)
      if @events.present?
       events = get_event_details(@events)
      else
       events = 0
      end
			response = {:status=>true, :total_event=>events.count, :events=>events}
			json_response(response)
		end


		def get_event_details(events)
      @events= []
      events.each do |event|
        @event_image = event.attachments.present? ? event.attachments.first.attachment.url : '/default_image.jpg';
        @events << {:title=>event.title, :id=>event.id, :description=>event.description, :ticket_available => event.ticket_available, :cost=> event.cost, :currency=> event.currency, :contact_number => event.contact_number, :image=> @event_image,
        :cost_offers=>event.cost_offers, :email=>event.email, :event_type => event.event_type, :status=> event.status,:approved=>event.approved, :event_categories=> event.categories.map(&:name), :event_artists=>event.artists.map(&:name), :event_added_by=>event.user.user_name,:event_location=>event.locations.first.address,:latitude=>event.locations.first.latitude,:longitude=>event.locations.first.longitude,:city=>event.locations.first.city,:state=>event.locations.first.state,:venue=>event.locations.first.venue,:country=>event.locations.first.country, :event_date=>event.event_adver_dates.map{|a| [a.start_date, a.end_date]}.flatten!}
      end
      return @events
    end
	end
end