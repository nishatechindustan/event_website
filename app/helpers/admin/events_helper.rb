module Admin::EventsHelper

	def convert_date_time_to_time(time)
		time.strftime("%I:%M%p")
	end
end
