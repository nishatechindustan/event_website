class Advertise < ApplicationRecord
    attr_accessor :advertise_date
    has_many :event_adver_dates , as: :event_adver_datable, :dependent => :destroy
    validates :organization_name, :contact_person, :contact_number, :event_type, presence: true
    validates :contact_number, :numericality => {:only_integer => true}
    after_save :add_advertise_dates

    def add_advertise_dates
		if self.event_adver_dates.present?
			advertise = EventAdverDate.find_by(event_adver_datable_id: self.id, event_adver_datable_type: "Advertise")
			advertise.update(advertise_date)
		else
			self.event_adver_dates.create(advertise_date)
		end
	end
end
