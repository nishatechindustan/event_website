class App::Api::Admin::DashboardsController < AdminController

	
	def usr_event
		current_user = User.find_by_auth_token(params[:auth_token])
	    if current_user.is_admin
		    user_count = (User.all - [current_user]).count
		    event_count = Event.all.count
		    today_events = Event.where(:created_at => (Date.today.beginning_of_day..Date.today.end_of_day)).count
		    response = {:status=>true, :user_count=>user_count,:event_count=>event_count, :today_event=>today_events }
		else
			user_events = current_user.events.count
			response = {:status=>true, :events=>user_events}
		end

		render :json=>response
	end

end
