class Advertise < ApplicationRecord
    validates :organization_name, :contact_person, :contact_number, :event_type, presence: true
    
end
