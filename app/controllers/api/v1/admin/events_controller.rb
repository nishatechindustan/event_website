module Api::V1::Admin
  class EventsController < ApiController
    # callbacks
    before_action :authenticate_request! , only:[:create,:get_event_list,:latest_event,:event_list]
    before_action :get_category_and_artist ,only:[:create,:new, :edit, :update, :show]
    before_action :get_event_id ,only:[:edit, :destroy, :update ,:show, :change_status,:event_approve_unapprove]
    before_action :get_event_data ,only:[:edit, :update, :show]
    
    def index
      @events =  Event.all
      events= []
        @events.each do |event|
          @event_image = event.attachments.present? ? event.attachments.first.attachment.url : '/default_image.jpg';
          events <<{:title=>event.title, :id=>event.id, :description=>event.description, :ticket_available => event.ticket_available, :cost=> event.cost, :currency=> event.currency, :contact_number => event.contact_number, :image=> @event_image,
          :cost_offers=>event.cost_offers, :email=>event.email, :event_type => event.event_type, :status=> event.status, :approved=>event.approved, :event_categories=> event.categories.map(&:name), :event_added_by=>event.user.user_name,:event_location=>event.locations.first.address,:latitude=>event.locations.first.latitude,:longitude=>event.locations.first.longitude, :event_date=>event.event_adver_dates.map{|a| [a.start_date, a.end_date]}.flatten!}
        end
      render :json=>{:status=>true, :events=>events, :count=> @events.count}
    end

    def create
      user||= @current_user
      if user.present?
        @event = user.events.new(event_params)
        @event.category_ids = JSON.parse(params[:category_ids])
        @event.artist_ids = JSON.parse(params[:artist_ids])
        @event.event_location = event_location
        @event.event_dates = event_dates
        if @event.save
          if event_image_param.present?
           @event.attachments.create(event_image_param)
          end
          render :json=>{:message=> "Event successfuly added", :status=> true, :event=>@event}
        else
          render :json=>{:errors=>@event.errors.full_messages, :status=> false}
        end
      else
        render :json=>{:message=> "Something went wrong", :status=> false}
      end
    end

    def edit
      @event_image = @event.attachments.present? ? @event.attachments.first.attachment.url : '/default_image.jpg';
      @event_currency = @event.currency.present? ? @event.currency: ''
      event_date_time = {:start_date=>@event_dates.start_date,:end_date=>@event_dates.end_date ,:start_time=>@event_dates.start_time,:end_time=>@event_dates.end_time}
      event_location= {:address=>@event_location.address,:latitude=>@event_location.latitude,:longitude=>@event_location.longitude,:venue=>@event_location.venue,:locality=> @event_location.city,:administrative_area_level_1=>@event_location.state,:country=>@event_location.country}
      response = {:event_categories=>@event_categories.map(&:id), :event_location=>event_location,
        :event_artists=>@event_artists.map(&:id),:event_date=>event_date_time,:event=>@event, :event_image=>@event_image}
      render :json=>{:status=> true,:data=>response}
    end

    def update
      @event.category_ids = JSON.parse(params[:category_ids])
      @event.artist_ids = JSON.parse(params[:artist_ids])
      @event.event_location = event_location
      @event.event_dates = event_dates
      if @event.update(event_params)
        if event_image_param.present?
          if @event.attachments.present?
            @event.attachments.update(event_image_param)
          else
            @event.attachments.create(event_image_param)
          end
        end
        render :json=>{:message=> "Event Update successfuly.", :status=> true, :event=>@event}
      else
        render :json=>{:status=> false, :errors=>@event.errors.full_messages}
      end
    end

    def destroy
      if @event.destroy
        render :json => {:status=> true, :message=> "Event has been Deleted successfully.", :data => @event}
      else
        render :json => {:status=> false, :messages=> @event.errors.full_messages}
      end
    end

    def delete_events
      @events = Event.where(:id=> params[:event_ids])
      if @events.destroy_all
        render :json => {:status=> true, :message=> "Event has been Deleted successfully."}
      end
    end

    def show
      @event_image = @event.attachments.present? ? @event.attachments.first.attachment.url : '/default_image.jpg';
      @event_currency = @event.currency.present? ? @event.currency: ''
      event_date_time = {:start_date=>@event_dates.start_date,:end_date=>@event_dates.end_date ,:start_time=>@event_dates.start_time,:end_time=>@event_dates.end_time}
      event_location= {:address=>@event_location.address,:latitude=>@event_location.latitude,:longitude=>@event_location.longitude,:venue=>@event_location.venue,:locality=> @event_location.city,:administrative_area_level_1=>@event_location.state,:country=>@event_location.country}
      response = {:event_categories=>@event_categories.map(&:name), :event_location=>event_location,
        :event_artists=>@event_artists.map(&:name),:event_date=>event_date_time,:event=>@event, :event_image=>@event_image}
      render :json=>{:status=> true,:data=>response}
    end

    # using this method show datatable records 
    def get_event_list
      events = Event.evnt_list(params, @current_user)
      render :json=> events
      # render :json => {:data=>events[:events], :status=>true ,:draw=>params[:draw], :recordsTotal=>events[:recordsTotal], :recordsFiltered=>events[:recordsFiltered]}
    end

    def latest_event
      event_details = Event.fetch_today_event_list(params)
      puts "------------------------- before"
      puts event_details
      puts "--------------------------after"
      # events=[]
     #  if event_details
     # events.each do |event|
     #    @event_image = event.attachments.present? ? event.attachments.first.attachment.url : '/default_image.jpg';
     #    events <<{:title=>event.title, :id=>event.id, :description=>event.description, :ticket_available => event.ticket_available, :cost=> event.cost, :currency=> event.currency, :contact_number => event.contact_number, :image=> @event_image,
     #    :cost_offers=>event.cost_offers, :email=>event.email, :event_type => event.event_type, :status=> event.status,:approved=>event.approved, :event_categories=> event.categories.map(&:name), :event_artists=>event.artists.map(&:name), :event_added_by=>event.user.user_name,:event_location=>event.locations.first.address,:latitude=>event.locations.first.latitude,:longitude=>event.locations.first.longitude,:city=>event.locations.first.city,:state=>event.locations.first.state,:venue=>event.locations.first.venue,:country=>event.locations.first.country, :event_date=>event.event_adver_dates.map{|a| [a.start_date, a.end_date]}.flatten!}
     #  end
      render :json=> event_details
      # console.log(events)
      #render :json=>events
      # render :json => {:data=>events[:events], :status=>true ,:draw=>params[:draw], :recordsTotal=>events[:recordsTotal], :recordsFiltered=>events[:recordsFiltered]}
    end

    def unapprove_event
      events = Event.fetch_unapprove_event_list(params)
      render :json => {:data=>events[:events], :status=>true ,:draw=>params[:draw], :recordsTotal=>events[:recordsTotal], :recordsFiltered=>events[:recordsFiltered]}
    end

    def event_list
      if params[:event_type] && params[:event_type].include?("passed")
        events = Event.passed_event(params)
      else
        events= Event.evnt_list(params,@current_user)
      end
      render :json => {:data=>events[:events], :status=>true ,:draw=>params[:draw], :recordsTotal=>events[:recordsTotal], :recordsFiltered=>events[:recordsFiltered]}
    end

    def change_status
      response = Event.changeStatus(@event)
      render :json=>response
    end
    
    def event_approve_unapprove
      response = Event.changeEvent(@event)
      render :json=>response
    end

    private

    def event_params
      params.require(:event).permit(:title,:description,:ticket_available,:email,:currency, :cost, :contact_number, :cost_offers, :event_type)
    end

    def get_category_and_artist
      @categories = Category.all
      @artists = Artist.all
    end

    def event_image_param
      params.require(:event).permit(:attachment)
    end

    def get_event_id
      @event = Event.find params[:id]
    end

    def event_location
      params.require(:location).permit!
    end

    def event_dates
      params.require(:event_date).permit!
    end

    def get_event_data
      @event_categories =  @event.categories
      @event_artists =  @event.artists
      @event_location = @event.locations.first
      @event_dates = @event.event_adver_dates.first
    end
  end
end
