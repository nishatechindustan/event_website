require 'rails_helper'

RSpec.describe App::Api::Web::AdvertisesController, type: :controller do
	# describe "advertise#index API" do
 	#    let!(:advertise) { FactoryBot.create(:advertise) }

	#     it "all advertise data" do
	#       get :index
	#       json = JSON.parse(response.body)
	#       puts json
	#     end
 	#  	end
 	describe "GET 'advertise'" do
	    before :each do
	        @advertise = Advertise.all
	    end
	    it "returns http success" do
	      get 'index'
	      expect(response).to be_successful
	    end
  	end
  	describe "#create" do
		it "creates advertise" do 
			advertise_date = {:start_date=>"12/2/2018", :end_date=> "12/3/2018"}
	  		advertise_params = FactoryBot.attributes_for(:advertise)
	  		expect { post :create, :params => { :advertise => advertise_params,:advertise_date => {:start_date=>"12/2/2018", :end_date=> "12/3/2018"}  } }.to change(Advertise, :count).by(1) 
		end
	end
	describe "#update" do
		let!(:advertise) { FactoryBot.create(:advertise) }
	    before do
	        put :update, { id: advertise.id }.merge(advertise)
	    end
 	end
end
