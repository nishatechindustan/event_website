module Requests  
	include Warden::Test::Helpers
    module JsonHelpers
      def json
        JSON.parse(last_response.body)
      end
    end

    def create_new_event
    	@user||= @user1
    	category = create(:category)
	    artist = create(:artist)
	    @event = @user.events.new(valid_attr)
	    @event.artist_ids = {:artist =>artist.id}
	    @event.category_ids = {:category =>category.id}
	    @event.save
	    @event.categories << Category.where(id: category.id)
	    @event.artists << Artist.where(id: category.id)
	    @event.locations.create(location_params) 
	    @event.event_adver_dates.create(eventdate_params)
	    event_image= @event.attachments.create!(valid_attributes)
    end

    def sign_in(resource_or_scope, resource = nil)
	    before(:each) do
	      @request.env["devise.mapping"] = Devise.mappings[:admin]
	      user = FactoryBot.create(:user)
	      sign_in :user, user # sign_in(scope, resource)
	    end
  	end

end 

RSpec.configure do |config|
  config.include Requests, :type=>:controller
end 