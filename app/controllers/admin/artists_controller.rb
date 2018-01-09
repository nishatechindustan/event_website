class Admin::ArtistsController < AdminController
  before_action :get_artist, only: [:edit, :show, :update,:destroy]
  
  #show all Artist
  def index
    @artists = Artist.all
  end

  #initialize Artist
  def new
    @artist = Artist.new
  end
  #add new Artist
  def create
    @artist = Artist.new(artist_params)
    if @artist.save
      if artist_image_param[:attachment].present?
        @artist.attachments.create(artist_image_param)
      end
      flash[:notice] =  "New artist was added successfully."
      redirect_to admin_artists_path
    else
      flash[:errors] = @artist.errors.full_messages
      render :new 
    end    
  end

  #edit artist
  def edit
    
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
      flash[:notice] = "Artist has been updated successfully."
    else
      flash[:errors] = @artist.errors.full_messages
      #render :edit
    end
    redirect_to edit_admin_artist_path(@artist)
  end

  #show only one artist using artist id
  def show
  end

  # delete artist
  def destroy
    if @artist.destroy
      flash[:notice] = "Artist Deleted."
      redirect_to admin_artists_path
    else
      flash[:errors] = @artist.errors.full_messages
      redirect_to admin_artists_path
    end
  end

  private

  # callback use for get artist id before call edit, show, destroy, update
  def get_artist
    @artist = Artist.find params[:id]
  end

  # using strong paramter for saved records
  def artist_params
    params.require(:artist).permit(:name, :address, :description)
  end

  def artist_image_param
    params.require(:artist).permit(:attachment)
  end

end
