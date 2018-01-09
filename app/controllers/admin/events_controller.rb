class Admin::EventsController < AdminController
  before_action :get_category_and_artist ,only:[:create,:new, :edit, :update, :show]
  before_action :get_event_id ,only:[:edit, :destroy, :update ,:show]
  before_action :get_event_data ,only:[:edit, :update, :show]
  def index
  @events =  Event.all    
  end

  def new
    @event = Event.new
  end
  def create
    @event = current_user.events.new(event_params)

    if check_param_valid
      @event.category_ids = params[:category_ids]
      @event.artist_ids = params[:artist_ids]
      @event.event_location = event_location
      @event.event_dates = event_dates
      if @event.save
        if event_image_param.present?
         @event.attachments.create(event_image_param)
        end
        flash[:notice] = "Event successfuly added"
        redirect_to admin_events_path

      else
        flash[:errors] = @event.errors.full_messages
       render "new"
      end
    else
     flash[:notice] = "please check the details." 
     render "new"
    end
  end

  def edit
    @event_currency = @event.currency.present? ? @event.currency: ''
  end

  def update
      @event.category_ids = params[:category_ids]
      @event.artist_ids = params[:artist_ids]
      @event.event_location = event_location
      @event.event_dates = event_dates
    if check_param_valid
        if @event.update(event_params)
          if event_image_param.present?
            if @event.attachments.present?
              @event.attachments.update(event_image_param)
            else
              @event.attachments.create(event_image_param)
            end
          end

          flash[:notice]= "Event Update successfuly."
          redirect_to edit_admin_event_path(@event)
        else
          flash[:errors] = @event.errors.full_messages
          render "edit"
        end
    else
      flash[:notice] = "please check the details." 
      render "edit"
    end
  end

  def destroy
    if @event.destroy
      flash[:notice] = "Event Deleted successfully."
      redirect_to admin_events_path
    else
      flash[:errors] = @event.errors.full_messages
      redirect_to admin_events_path
    end
  end

  def show
   # @event_categories = @event.categories.map(&:name)
   # @event_artists = @event.artists.map(&:name)
   @event_currency = @event.currency.present? ? @event.currency: ''
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

  def check_param_valid 
    if event_location[:address].present? && event_location[:latitude].present? && event_location[:longitude].present? && event_location[:venue].present? && event_dates[:start_date].present? && event_dates[:end_date].present? && event_dates[:start_time].present?&& event_dates[:end_time].present?
      return true
    else
      return false
    end
  end
end
