require 'rails_helper'

RSpec.describe App::Api::Web::ContactsController, type: :controller do

	describe "GET #index" do

	    it 'successfully renders the index template on GET /' do

	      expect(response).to be_successful
	    end

	    it 'returns all contacts us users /' do
	      expect(response).to be_successful
	    end
  	end

  	describe "POST #create" do
      context "with valid params" do
        it "creates a new contact us " do
         
        end
      end
  	end
end
