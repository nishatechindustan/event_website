class EventAdverDate < ApplicationRecord
 belongs_to :event_adver_datable,  polymorphic: true
end
