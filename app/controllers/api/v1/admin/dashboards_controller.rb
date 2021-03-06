module Api::V1::Admin
	class DashboardsController < ApiController
		 before_action :authenticate_request! , only:[:usr_event]
		
		def usr_event
		    if @current_user && @current_user.is_admin
			    user_count = (User.all - [@current_user]).count
			    event_count = Event.all.count
			    today_events = Event.fetch_today_event
			    response = {:status=>true, :user_count=>user_count,:event_count=>event_count, :today_event=>today_events }
			elsif @current_user
				user_events = @current_user.events.count
				response = {:status=>true, :events=>user_events}
			else
			response = {:status => false, :message=> "invalid token"}
			end
			json_response(response)
		end

		def get_chart_data
			total_event = Event.all.count
			free_event = Event.where(:event_type=> 0).count
			sponsored_event = Event.where(:event_type=> 1).count
			deactive_event= Event.where(:status=> false).count
			active_event= Event.where(:status=> true).count
			today_events = Event.fetch_today_event
			response = {:status=>true, :total_event=> total_event,:free_event=>free_event,:sponsored_event=>sponsored_event,:active_event=>active_event,:deactive_event=>deactive_event,:today_events=>today_events}
			render :json=>response
		end
	end
end

