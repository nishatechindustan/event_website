require 'rails_helper'

RSpec.describe App::Api::Web::ContactsController, type: :controller do

	describe "GET #index" do

	    it 'successfully renders the index template on GET /' do

	      expect(response).to be_successful
	    end

	    it 'returns all contacts_us users /' do
	      expect(response).to be_successful
	    end
  	end

	describe "#create" do
		context "with valid params" do
			it "creates advertise" do 
		  		expect { post :create, :params =>{:first_name=>"ashish", :last_name=>"mishra", :email=> "ashish.techindustan@gmail.com", :description=> "hii"} }.to change(Contact, :count).by(1) 
			end
		end
	end
	describe "#create of the  customer_feedback" do
		context "with valid params" do
			it "creates customer feedback" do 
		  		expect { post :create, :params =>{:name=>"ashish",:email=> "ashish.techindustan@gmail.com", :description=> "hii"} }
			end
		end
	end
end
