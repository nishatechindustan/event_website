require 'rails_helper'

RSpec.describe EventAdverDate, type: :model do
  it { should belong_to(:event_adver_datable) }
end
