module DifferenceDateHelper

	def distance_of_day(start_date, end_date)
	if (Date.today==start_date && Date.today<end_date)
		return "Ongoing"
	elsif (Date.today<start_date)
		days = (start_date- Date.today).to_i
		return "#{pluralize(days, 'day',"days")} left"
	else
		return "Elapsed"		
	end	
	end
end
