require 'rails_helper'
require 'shoulda/matchers'


RSpec.describe Contact, type: :model do
	# contact = Contact.new
	# contact = FactoryBot.build(:contact)
	let(:valid_attr) { attributes_for(:contact) }

	context 'validation tests' do
		let(:contact) { Contact.new(valid_attr) }

		before do
       	 Contact.create(valid_attr)
        end

		it 'ensure first name presence' do
			# contact = Contact.new(last_name: 'mishra', email:"ashish.techindustan@gmail.com").save
			# expect(contact).to eq(false)
			 expect(contact).to validate_presence_of(:first_name)
		end
		it 'ensure last name presence' do
			# contact = Contact.new(first_name: 'ashish', email:"ashish.techindustan@gmail.com").save
			# expect(contact).to eq(false)
			expect(contact).to validate_presence_of(:last_name)
		end
		it 'ensure email name presence' do
			# contact = Contact.new(last_name: 'mishra', first_name: "ashish").save
			# expect(contact).to eq(false)
			expect(contact).to validate_presence_of(:email)
		end

		# it 'should save successfully' do
		# 	# contact = Contact.new(first_name: 'ashish', last_name: "mishra", email:"ashish.techindustan@gmail.com").save
		# 	# expect(contact).to eq(true)
		# 	Contact.create(valid_attr)
		# end

		it "requires the email to look like an email" do
            contact.email = "brown"
            expect(contact).to_not be_valid
        end

        it "requires a unique email" do
            expect(contact).to validate_uniqueness_of(:email)
        end
	end

    # context "validations" do
    #     it { is_expected.to validate_uniqueness_of(:email)}
    # end
end
