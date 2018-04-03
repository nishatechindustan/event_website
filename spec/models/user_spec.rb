require 'rails_helper'

RSpec.describe User, type: :model do
	let(:valid_attr) { attributes_for(:user) }

	describe "users model validations" do
		it { should validate_length_of(:user_name).is_at_most(50) }
		it { should validate_uniqueness_of(:email).scoped_to(:provider).case_insensitive }
		it { is_expected.to validate_presence_of(:email).on(:create)}
		it { is_expected.to validate_presence_of(:password).on(:create)}
		it do
    		should validate_confirmation_of(:password).on(:create)
		  end
		it { should validate_length_of(:password).on(:create) }
	end

	describe "users models association validations" do
		it { should have_many(:locations).dependent(:destroy)}
		it { should have_many(:events).dependent(:destroy)}
		it { should have_many(:attachments).dependent(:destroy)}
	end

	describe "#create" do
		let(:user) { User.new(valid_attr) }
	    it "calls status method" do
	      expect(user).to receive(:set_status)
	      user.save
	    end
	end

end
