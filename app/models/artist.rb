class Artist < ApplicationRecord
	has_many :locations
	validates :name, presence: true
	has_many :attachments, as: :attachable, dependent: :destroy
	 has_many :event_artists#, dependent: :destroy
	 has_many :events, through: :event_artists
end