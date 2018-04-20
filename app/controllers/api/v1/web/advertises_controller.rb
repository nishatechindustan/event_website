class Api::v1::Web::AdvertisesController < ApplicationController
	# before_action :get_advertise, only: [:update]

	def index
		advertises=[]
		Advertise.all.each do|advertise|
			advertise_detail = {:organization_name=>advertise.organization_name,:contact_person=>advertise.contact_person,:contact_number=>advertise.contact_number,:event_category=>advertise.event_type}
		advertise_date_details = {:start_date=>advertise.event_adver_dates.first.start_date,:end_date=>advertise.event_adver_dates.first.end_date}
			advertises <<{:advertise=>advertise_detail, :advertise_date=>advertise_date_details}
		end
		response = {:status=>true, :data=>advertises}
		json_response(response)
	end

	def create
		if params[:advertise_date][:start_date].present? && params[:advertise_date][:end_date].present?
			advertise = Advertise.new(advertise_params)
			advertise.advertise_date = advertise_date_data
			if advertise.save
				render :json =>{:status=>true, :message=>"Your Details successfully submitted"}
			else
				render :json => {:status=>false,:errors=>advertise.errors.full_messages}
			end
		else
			render :json=>{:status=>false, :message=> "Please fill the all details"}
		end
	end

	def update
		@advertise = Advertise.find(params[:id])
		if params[:advertise_date][:start_date].present? && params[:advertise_date][:end_date].present?
			@advertise.advertise_date = advertise_date_data
			if @advertise.update(advertise_params)
				render :json =>{:status=>true, :message=>" Advertise Details successfully Updated"}
			else
				render :json => {:status=>false,:errors=>@advertise.errors.full_messages}
			end	
		else
			render :json=>{:status=>false, :message=> "Please fill the  details"}
		end	
	end

	private

	def advertise_params
		params.require(:advertise).permit(:organization_name, :contact_person, :contact_number, :event_type)
	end

	def advertise_date_data
   	 params.require(:advertise_date).permit!
  	end
 #  def get_advertise
 #  	@advertise = Advertise.find(params[:id])
 #  end
end
