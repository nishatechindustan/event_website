class App::Api::Admin::DashboardsController < AdminController

	
	def usr_event
		current_user = User.find_by_auth_token(params[:auth_token])
	    if current_user.is_admin
		    user_count = (User.all - [current_user]).count
		    event_count = Event.all.count
		    response = {:status=>true, :user_count=>user_count,:event_count=>event_count }
		else
			user_events = current_user.events
			response = {:status=>true, events=>user_events}
		end

		render :json=>response
	end

end
