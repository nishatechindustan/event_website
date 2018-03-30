require 'rails_helper'

RSpec.describe CustomerFeedback, type: :model do
	it { is_expected.to validate_presence_of(:name) }
	it { is_expected.to validate_presence_of(:description) }

	describe '#email' do
		it { should_not allow_value("blah").for(:email) }
		it { should allow_value("a@b.com").for(:email) }
		it { is_expected.to validate_presence_of(:email) }
		it { is_expected.to validate_uniqueness_of(:email) }
	end
end
