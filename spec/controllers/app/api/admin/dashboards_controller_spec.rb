require 'rails_helper'

RSpec.describe App::Api::Admin::DashboardsController, type: :controller do
	let(:valid_attr) { attributes_for(:event)}
	let(:location_params) { attributes_for(:location)}
	let(:eventdate_params) { attributes_for(:event_adver_date)}
	 after(:all) {
	   FileUtils.rm_rf(Dir.glob("#{Rails.root}/public/system/*"))
	  }

	  let(:valid_attributes) {
	      {attachment: File.new(Rails.root + 'public/default_image.jpg') }
	  }
	before do
		@request.env["devise.mapping"] = Devise.mappings[:user]
		@user1 = User.create!(email: 'company_owner@test.com', password: 'p123456P', password_confirmation: 'p123456P', first_name: "Abc", last_name: "Def",user_name: 'ashish', is_admin: true)
		@user2 = User.create!(email: 'company_owner1@test.com', password: 'p123456P', password_confirmation: 'p123456P', first_name: "Abc", last_name: "Def",user_name: 'ashish')
		allow(controller).to receive(:authenticate_request!).and_return(true)
		create_new_event
	end

	describe "GET 'usr_event details list '" do
		context "if user is admin" do
	    before :each do
        @user = (User.all - [User.last]).count
        @event = Event.all.count
        today_evnt = Event.fetch_today_event
	    end
	    it "returns http success" do
	      get 'usr_event'
	      expect(response).to be_successful
	    end
	  end

		context "if user is not  admin" do
	    before :each do
	        @event = @user1.events.count
	    end
	    it "returns http success" do
	      get 'usr_event'
	      expect(response).to be_successful
	    end
		end
	end

	describe "GET 'chart  details list '" do
    before :each do
	    total_event = Event.all.count
			free_event = Event.where(:event_type=> 0).count
			sponsored_event = Event.where(:event_type=> 1).count
			deactive_event= Event.where(:status=> false).count
			active_event= Event.where(:status=> true).count
			today_events = Event.fetch_today_event
    end
    it "returns http success" do
      get 'get_chart_data'
      expect(response).to be_successful
    end
	end
end
