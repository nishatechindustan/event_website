require 'rails_helper'

RSpec.describe App::Api::Web::EventsController, type: :controller do
	before do
      #@user = User.create!(email: 'customer@test.com', password: '123456', password_confirmation: '123456', first_name: "Abc", last_name: "Def", base_role: BaseRole.find(:customer)).assign_base_role_permissions
      #@reminder=User.first.reminders.create!(weekday_num: '6', reminder_time: '10:20', treatment_kinds:[])
      user=create(:user)
      category = create(:category)
      artist = create(:artist)
       event = user.events.new()
       debugger		
   #    @reminder = create(:reminder,user:@user)  # <= this line changed
			# @reminder.treatment_kinds<<create(:treatment_kind)
   #    build(:reminder_item,reminder:@reminder)
   #    build(:reminder_item,reminder:@reminder)
  	end
  	 describe "GET 'today_event'" do
	    before :each do
	      # @today_event = 
	    end

	    it "returns http success" do
	      get 'today_event'
	      expect(response).to be_successful
	    end
  	end
end

# user = FactoryBot.create :user
# 		artist = FactoryBot.create :artist
# 		category = FactoryBot.create :category
# 	  let(:valid_attr) { attributes_for(:event)}
# 	  before do
# 	  	user.events.create(valid_attr)
# 	  end