require 'rails_helper'

RSpec.describe Advertise, type: :model do
  let(:valid_attr) { attributes_for(:advertise) }

	context 'validation test' do

		let(:advertise) {Advertise.new(valid_attr)}
		before do
			Advertise.create(valid_attr)
		end

		it 'is not valid without a organization name ' do
			expect(advertise).to validate_presence_of(:organization_name)
		end
		it 'is not valid without a contact person ' do
			expect(advertise).to validate_presence_of(:contact_person)
		end
		it 'is not valid without a  contact number ' do
			expect(advertise).to validate_presence_of(:contact_number)
		end
		it 'is not valid without a event type ' do
			expect(advertise).to validate_presence_of(:event_type)
		end
		# it 'should update advertise date to advertise' do      
		#    	advertise  = Advertise.create(valid_attr)
		#   	advertise_date = advertise.event_adver_dates.create(:start_date=>"20/3/2018", :end_date=>"20/3/2018")
		#   	advertise_record = EventAdverDate.find_by(:event_adver_datable_id=> advertise.id, :event_adver_datable_type=> "Advertise")
		  	
		#     advertise_record.update(:start_date=>"20/3/2018", :end_date=>"20/3/2018")                          
		# end
	end

	context 'validation' do
		it {should validate_numericality_of(:contact_number).only_integer }
		it { should callback(:add_advertise_dates).after(:save) }
	end
end
