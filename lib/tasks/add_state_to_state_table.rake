namespace :add_state_list do
	desc "Adding state to state table"
	task :to_state => :environment do
		states = [{name: 'ANDAMAN AND NICOBAR ISLANDS'},
					{name: 'ANDHRA PRADESH'},
					{name: 'ARUNACHAL PRADESH'},
					{name: 'ASSAM'},
					{name: 'BIHAR'},
					{name: 'CHATTISGARH'},
					{name: 'CHANDIGARH'},
					{name: 'DAMAN AND DIU'},
					{name: 'DELHI'},
					{name: 'DADRA AND NAGAR HAVELI'},
					{name: 'GOA'},
					{name: 'GUJARAT'},
					{name: 'HIMACHAL PRADESH'},
					{name: 'HARYANA'},
					{name: 'JAMMU AND KASHMIR'},
					{name: 'JHARKHAND'},
					{name: 'KERALA'},
					{name: 'KARNATAKA'},
					{name: 'LAKSHADWEEP'},
					{name: 'MEGHALAYA'},
					{name: 'MAHARASHTRA'},
					{name: 'MANIPUR'},
					{name: 'MADHYA PRADESH'},
					{name: 'MIZORAM'},
					{name: 'NAGALAND'},
					{name: 'ORISSA'},
					{name: 'PUNJAB'},
					{name: 'PONDICHERRY'},
					{name: 'RAJASTHAN'},
					{name: 'SIKKIM'},
					{name: 'TAMIL NADU'},
					{name: 'TRIPURA'},
					{name: 'UTTARAKHAND'},
					{name: 'UTTAR PRADESH'},
					{name: 'WEST BENGAL'},
					{name: 'TELANGANA'}
				]
		states.each do |state|
			State.create(state)
		end			
	end  
end