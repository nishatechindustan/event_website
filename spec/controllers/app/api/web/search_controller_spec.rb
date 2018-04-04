require 'rails_helper'

RSpec.describe App::Api::Web::SearchController, type: :controller do
	describe '#search' do
		params = {"state" =>'chandigarh'}
	    it 'should return results' do
	      get :search 
	      @events = Event.search(params)
	     expect(@events).to eq([])
	    end
  	end
end
