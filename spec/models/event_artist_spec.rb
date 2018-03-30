require 'rails_helper'

RSpec.describe EventArtist, type: :model do
	it { should belong_to(:artist) }
	it { should belong_to(:event) }
end
