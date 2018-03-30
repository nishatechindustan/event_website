require 'rails_helper'

RSpec.describe Category, type: :model do
	it { is_expected.to validate_presence_of(:name) }
	it { should validate_uniqueness_of(:name) }
	it { should have_many(:event_categories)}
	it { should have_many(:events).through(:event_categories).dependent(:destroy) }
end
