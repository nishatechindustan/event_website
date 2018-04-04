require 'rails_helper'

RSpec.describe App::Api::Admin::EventsController, type: :controller do
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
end
