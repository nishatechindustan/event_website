require 'rails_helper'

RSpec.describe App::Api::Web::EventsController, type: :controller do
  	let(:valid_attr) { attributes_for(:event)}
  	let(:location_params) { attributes_for(:location)}
  	let(:eventdate_params) { attributes_for(:event_adver_date)}

	before(:each) do
      user=create(:user)
      category = create(:category)
      artist = create(:artist)
       @event = user.events.new(valid_attr)
       @event.artist_ids = {:artist =>artist.id}
       @event.category_ids = {:category =>category.id}
       @event.save
       @event.categories << Category.where(id: category.id)
       @event.artists << Artist.where(id: category.id)
       @event.locations.create(location_params) 
       @event.event_adver_dates.create(eventdate_params)
  	end

  	describe "GET 'today_event'" do
  		let(:query) { '#{Date.today}' }
	    it "returns http success" do
	      get 'today_event'
	      expect(response).to be_successful
	    end
  	end

  	describe "GET 'paid_event'" do
	    it "returns http success" do
	      get 'paid_event'
	      expect(response).to be_successful
	    end
  	end

  	describe "GET 'free_event'" do
	    it "returns http success" do
	      get 'free_event'
	      expect(response).to be_successful
	    end
  	end

  	describe "GET 'recent_event'" do
	    it "returns http success" do
	      get 'recent_event'
	      expect(response).to be_successful
	    end
  	end

  	describe "GET 'event_details'" do
  		
	    it "returns http success" do
	      get 'event_details',params: {id: @event.id} 
	      expect(response).to be_successful
	    end
  	end
end
