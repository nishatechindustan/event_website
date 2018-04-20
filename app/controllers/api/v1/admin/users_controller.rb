class Api::v1::Admin::UsersController < AdminController
	# callbacks
	before_action :authenticate_request!, except: [:edit, :delete_user,:change_status, :update]
	before_action :get_user, only: [:delete_user, :edit, :change_status, :update]

	def all_users
	    @users = User.all - [@current_user]
	    users= []
	    @users.each do |user|
	      @user_image =  user.attachments.present? ? user.attachments.first.attachment.url : '/default_image.jpg';
	      users<<{:auth_token=>user.auth_token, :id=>user.id, :email=>user.email, :user_name => user.user_name, :first_name=> user.first_name, :last_name=> user.last_name, :is_admin => user.is_admin, :image=> @user_image}
	    end
    	render :json =>{result: users, status: 200}
	end

	def edit
		@user_image =  @user.attachments.present? ? @user.attachments.first.attachment.url : '/default_image.jpg';
		user = {:auth_token=>@user.auth_token, :id=>@user.id, :email=>@user.email, :user_name => @user.user_name, :first_name=> @user.first_name, :last_name=> @user.last_name, :is_admin => @user.is_admin, :image=> @user_image}
		render :json =>{data: user, status: true}
	end

	def user_edit
		@user||= @current_user
		@user_image =  @user.attachments.present? ? @user.attachments.first.attachment.url : '/default_image.jpg';
		user = {:id=>@user.id, :email=>@user.email, :user_name => @user.user_name, :first_name=> @user.first_name, :last_name=> @user.last_name, :is_admin => @user.is_admin, :image=> @user_image}
		render :json =>{data: user, status: true}
	end

	# users profile
	def show
	  user||= @current_user
		if user.present?
			user_events = user.events
			@user_image =  user.attachments.present? ? user.attachments.first.attachment.url : '/default_image.jpg';
		    @user = {:auth_token=>user.auth_token, :id=>user.id, :email=>user.email, :user_name => user.user_name, :first_name=> user.first_name, :last_name=> user.last_name, :is_admin => user.is_admin, :image=> @user_image}
		    if user_events.present?
		    	events = []
		    	user_events.each do|event|
		    		@event_categories =  event.categories
    				@event_artists =  event.artists
		    		@event_location = event.locations.first
    				@event_dates =    event.event_adver_dates.first
		    		@event_image = event.attachments.present? ? event.attachments.first.attachment.url : '/default_image.jpg';
				    @event_currency = event.currency.present? ? event.currency: ''
				    event_date_time = {:start_date=>@event_dates.start_date,:end_date=>@event_dates.end_date ,:start_time=>@event_dates.start_time,:end_time=>@event_dates.end_time}
				    event_location= {:address=>@event_location.address,:latitude=>@event_location.latitude,:longitude=>@event_location.longitude,:venue=>@event_location.venue}
				    events<< {:event_categories=>@event_categories.map(&:name), :event_location=>event_location,
				      :event_artists=>@event_artists.map(&:name),:event_date=>event_date_time,:event=>event, :event_image=>@event_image}
				end
				user_events = {:status=> true, :data=> events}
		    else
		    	user_events = {:status=> true, :data=>"No Event Are Present."}
		    end
		    render :json =>{data: @user, user_events: user_events, status: 200}
		else
 			render :json =>{message: "something went wrong", :status=> false}
		end
	end

	#update user
	def update
		# @user||= @current_user
		if @user.present?
			if @user.update(users_params)
				if params[:user][:attachment].present? && avatar_image_params.present?
					@user_image = @user.attachments.where(:attachable_id => @user.id, :attachable_type => "User")
					if @user_image.present?
						@user.attachments.update(avatar_image_params)
					else
						@user.attachments.create(avatar_image_params)
					end
				end
			@user_image =  @user.attachments.present? ? @user.attachments.first.attachment.url : '/default_image.jpg';
			userDetails = {:auth_token=>@user.auth_token, :email=>@user.email, :user_name => @user.user_name, :first_name=> @user.first_name, :last_name=> @user.last_name, :is_admin => @user.is_admin, :image=> @user_image}
			render :json=> {:status=> true, :message=>" Profile updated successfully", :userDetails=>userDetails}
		 	else
			 	render :json=> {:status=> false, :errors=>@user.errors.full_messages}
			end
		else
			render :json=> {:status=> false, :message=>"Invalid User Id"}
		end
	end

	def delete_user
		if @user.destroy
			render :json =>{:status=>true, :notice=> "User Deleted successfully", :data=>@user}
		else
			render :json => {:status=> false, :errors=> @user.errors.full_messages}
		end
  	end

  	#get_users_list nethods for get all list of users for datatable

  	def get_users_list
  		recordsTotal = (User.all - [@current_user]).count
  		users = []
	    search_value = params[:search][:value] if params[:search]
	    
	    if search_value.present?
	      @users = User.where('user_name ILIKE ? OR first_name ILIKE ?', "%#{search_value}%", "%#{search_value}%").order(:created_at => :desc).limit(params[:length].to_i).offset(params[:start].to_i).where.not(id: current_user)
	      recordsFiltered = @users.count
	    else
	      @users = User.where.not(id: current_user).order(:created_at => :desc).limit(params[:length].to_i).offset(params[:start].to_i)
	      recordsFiltered = recordsTotal
	    end

	   	@users.each do |user|
	      @user_image =  user.attachments.present? ? user.attachments.first.attachment.url : '/default_image.jpg';
	      users<<{:auth_token=>user.auth_token, :id=>user.id, :email=>user.email, :user_name => user.user_name, :provider=>user.provider,:uid=>user.uid, :first_name=> user.first_name, :last_name=> user.last_name, :is_admin => user.is_admin, :image=> @user_image, :status=>user.status}
	    end
	    render :json => {:data=>users, :status=>true ,:draw=>params[:draw], :recordsTotal=>recordsTotal, :recordsFiltered=>recordsFiltered}
  	end

  	def change_status
		response = User.changeStatus(@user) 
		render :json=>response 		
  	end


	# strong parameters for users prams
	def users_params
		params.require(:user).permit(:user_name, :first_name, :last_name, :email)
	end

	# for photo params

	def avatar_image_params
		params.require(:user).require(:attachment).permit(:attachment)
	end

	private

	def get_user
	  @user = User.find params[:id]
	end
end
