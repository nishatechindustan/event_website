require 'rails_helper'

RSpec.describe Event, type: :model do

	describe "Event model validations with title" do
		it { is_expected.to validate_presence_of(:title)}
	end

	describe "Event model associations" do
		it{ should belong_to(:user)}
		it { should have_many(:event_adver_dates).dependent(:destroy)}
		it { should have_many(:locations).dependent(:destroy)}
		it { should have_many(:event_categories)}
		it { should have_many(:categories).through(:event_categories).dependent(:destroy) }
		it { should have_many(:event_artists)}
		it { should have_many(:artists).through(:event_artists).dependent(:destroy) }
		it { should have_many(:attachments).dependent(:destroy) }
	end

	describe "callback in events models" do

	# describe "#save" do
	# 	let(:valid_attr) { attributes_for(:user) }
	# 	let(:event) {Event.new()}
	# 	it " create first event" do
	# 		user  = User.create(valid_attr)
	# 		#event = FactoryBot.create(:event)
	# 	end
	# end
		it { should callback(:add_event_locations).after(:save) }
		it { should callback(:add_event_dates).after(:save) }
		it { should callback(:remove_add_artist).after(:save) }
		it { should callback(:remove_add_categories).after(:save) }
	end

end
