require 'rails_helper'

RSpec.describe EventCategory, type: :model do
   it { should belong_to(:category) }
   it { should belong_to(:event) }
end
