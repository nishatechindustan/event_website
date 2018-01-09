class Category < ApplicationRecord
	validates :name, presence: true, uniqueness: true
	has_many :events, through: :event_categories
	has_many :event_categories#, dependent: :destroy
end
