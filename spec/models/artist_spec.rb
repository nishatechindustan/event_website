require 'rails_helper'

RSpec.describe Artist, type: :model do
	it { is_expected.to validate_presence_of(:name) }
	it { should have_many(:event_artists)}
	it { should have_many(:events).through(:event_artists).dependent(:destroy) }
	it { should have_many(:attachments).dependent(:destroy) }
end
