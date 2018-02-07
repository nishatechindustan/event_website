class App::Api::Admin::ArtistsController < AdminController
    
    #callbacks
  before_action :get_artist, only: [:show, :update,:destroy]

  #show all Artist
  def index
    artists= []
    recordsTotal = Artist.all.count
    search_value = params[:search][:value]
    
    if search_value.present?
      @artists = Artist.where('name ILIKE ? OR address ILIKE ?', "%#{search_value}%", "%#{search_value}%").order(:created_at).limit(params[:length].to_i).offset(params[:start].to_i)
      recordsFiltered = @artists.count
    else
      @artists = Artist.all.order(:created_at).limit(params[:length].to_i).offset(params[:start].to_i)
      recordsFiltered = recordsTotal
    end

    @artists.each do |artist|
      @artist_image =  artist.attachments.present? ? artist.attachments.first.attachment.url : '';
      artists<<{:id=>artist.id, :name=>artist.name, :address=> artist.address, :description=>artist.description, :image=> @artist_image}
    end

    render :json => {:data=>artists, :status=>true ,:draw=>params[:draw], :recordsTotal=>recordsTotal, :recordsFiltered=>recordsFiltered}
  end

  #add new Artist
  def create
    @artist = Artist.new(artist_params)
    if @artist.save
      if artist_image_param[:attachment].present?
        @artist.attachments.create(artist_image_param)
      end
      @artist_image =  @artist.attachments.present? ? @artist.attachments.first.attachment.url : '';
      artist = {:name=> @artist.name, :address=> @artist.address, :id=> @artist.id, :description=> @artist.description, :image=> @artist_image}
      render :json => {:status=> true, :messages=> "New artist was added successfully.", :data => artist}
    else
      render :json => {:status=> false, :message=>@artist.errors.full_messages}
    end
  end



  # update artist with according to id
  def update
    if @artist.update(artist_params)
      @artists = Artist.all
      if artist_image_param[:attachment].present?
       @artict_image =  @artist.attachments.find_by(:attachable_id => @artist.id, :attachable_type => "Artist")
        if @artict_image.present?
          @artict_image.update(artist_image_param)
        else
          @artist.attachments.create(artist_image_param)
        end
      end
      @artist_image =  @artist.attachments.present? ? @artist.attachments.first.attachment.url : '';
      artist = {:name=> @artist.name, :address=> @artist.address, :id=> @artist.id, :description=> @artist.description, :image=> @artist_image}
      render :json => {:status=> true, :messages=> "Artist has been updated successfully.", :data => artist}
    else
      render :json => {:status=> false, :message=>@artist.errors.full_messages}
    end
  end

  #show only one artist using artist id
  def show
  end

  # delete artist
  def destroy

    if @artist.destroy
      render :json => {:status=> true, :messages=> "Artist has been Deleted successfully.", :data => @artist}
    else
      render :json => {:status=> false, :messages=> @artist.errors.full_messages}
    end
  end

  private

  # callback use for get artist id before call edit, show, destroy, update
  def get_artist
    @artist = Artist.find params[:id]
  end

  # using strong paramter for saved records
  def artist_params
    params.require(:artists).permit(:name, :address, :description)
  end

  def artist_image_param
    params.require(:artists).permit(:attachment)
  end
end
