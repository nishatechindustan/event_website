class App::Api::Admin::ArtistsController < AdminController
    
  #callbacks
  before_action :get_artist, only: [:show, :update,:destroy, :edit, :change_status]

  #show all Artist
  def index
    artists= []
    recordsTotal = Artist.all.count
    search_value = params[:search][:value] if params[:search]
    
    if search_value.present?
      @artists = Artist.where('name ILIKE ? OR address ILIKE ? OR artist_type ILIKE ?', "%#{search_value}%", "%#{search_value}%","%#{search_value}%").order(sort_column + " " + sort_direction).limit(params[:length].to_i).offset(params[:start].to_i)
      recordsFiltered = @artists.count
    else
      @artists = Artist.all.order(sort_column + " " + sort_direction).limit(params[:length].to_i).offset(params[:start].to_i)
      recordsFiltered = recordsTotal
    end

    @artists.each do |artist|
      
      @artist_image =  artist.attachments.present? ? artist.attachments.first.attachment.url : '/default_image.jpg';
      artists<<{:id=>artist.id, :name=>artist.name, :address=> artist.address, :description=>artist.description, :type=> artist.artist_type, :image=> @artist_image, :status=>artist.status}
    end
    render :json => {:data=>artists, :status=>true ,:draw=>params[:draw], :recordsTotal=>recordsTotal, :recordsFiltered=>recordsFiltered}
  end

  def get_artist_list
    @artists = Artist.all
    render :json => {:data=>@artists, :status=>true}
  end

  #add new Artist
  def create
    @artist = Artist.new(artist_params)
    if @artist.save
      if artist_image_param[:attachment].present?
        @artist.attachments.create(artist_image_param)
      end
      @artist_image =  @artist.attachments.present? ? @artist.attachments.first.attachment.url : '/default_image.jpg';
      artist = {:name=> @artist.name, :address=> @artist.address, :id=> @artist.id, :description=> @artist.description,:artist_type=> @artist.artist_type, :image=> @artist_image}
      render :json => {:status=> true, :message=> "New artist was added successfully.", :data => artist}
    else
      render :json => {:status=> false, :errors=>@artist.errors.full_messages}
    end
  end



  # update artist with according to id
  def update
    if @artist.update(artist_params)
      if artist_image_param[:attachment].present?
       @artict_image =  @artist.attachments.find_by(:attachable_id => @artist.id, :attachable_type => "Artist")
        if @artict_image.present?
          @artict_image.update(artist_image_param)
        else
          @artist.attachments.create(artist_image_param)
        end
      end
      @artist_image =  @artist.attachments.present? ? @artist.attachments.first.attachment.url : '/default_image.jpg';
      artist = {:name=> @artist.name, :address=> @artist.address, :id=> @artist.id, :description=> @artist.description,:artist_type=> @artist.artist_type, :image=> @artist_image}
      render :json => {:status=> true, :message=> "Artist has been updated successfully.", :data => artist}
    else
      render :json => {:status=> false, :errors=>@artist.errors.full_messages}
    end
  end

  #show only one artist using artist id
  def show
  end

  # edit get details for edit with 'id'

  def edit
    if @artist.present?
      @artist_image = @artist.attachments.present? ? @artist.attachments.first.attachment.url : '/default_image.jpg';
      artist = {:name=> @artist.name, :address=> @artist.address, :id=> @artist.id, :description=> @artist.description, :artist_type=> @artist.artist_type, :image=> @artist_image}
     response = {:status=> true, :data=> artist}
    else
      response = {:status=> false, :message=> "something went wrong"}
    end
    render :json=> response
  end

  # delete  single artist
  def destroy

    if @artist.destroy
      render :json => {:status=> true, :message=> "Artist has been Deleted successfully.", :data => @artist}
    else
      render :json => {:status=> false, :errors=> @artist.errors.full_messages}
    end
  end

  def change_status
    response = Artist.changeStatus(@artist)
    render :json=>response
  end

  #  delete multiple artists
  def delete_artists
    @artists = Artist.where(:id=> params[:artists_ids])
    if @artists.destroy_all
      render :json => {:status=> true, :message=> "Artist has been Deleted successfully."}
    end
  end

  private

  # callback use for get artist id before call edit, show, destroy, update
  def get_artist
    @artist = Artist.find params[:id]
  end

  # using strong paramter for saved records
  def artist_params
    params.require(:artists).permit(:name, :address, :description, :artist_type)
  end

  def artist_image_param
    params.require(:artists).permit(:attachment)
  end

  def sort_column
    column_value  = params[:order]["0"][:column]  if params[:order]
    case column_value
    when "0"
      "name"
    when "1"
      "address"
    when "2"
      "description"
    when "3"
      "artist_type"
    when "4"
      "status"
    else
      "created_at"
    end   
  end

  def sort_direction
    if params[:order]
      params[:order]["0"][:dir] 
    else
      "DESC"
    end
  end
end
