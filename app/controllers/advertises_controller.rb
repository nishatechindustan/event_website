class AdvertisesController < ApplicationController
  def new
  	@advertise = Advertise.new
  end

	def create
		if params[:advertise_date].present?
			advertise = Advertise.new(advertise_params)
			advertise_date_params = {:start_date =>advertise_params[:advertise_date].split('-').first , :end_date=>advertise_params[:advertise_date].split('-').last }
			advertise.advertise_date = advertise_date_params
			if advertise.save
				flash[:message] = "Your Details successfully submitted"
				redirect_to root_path
			else
				flash[:errors] = advertise.errors.full_messages
				redirect_to new_advertise_path
			end
		else
			flash[:message] = "Please fill the all details"
			render "new"
		end
	end


	private
	def advertise_params
		params.permit(:organization_name,:advertise_date, :event_type, :contact_person, :contact_number)
		
	end
end
