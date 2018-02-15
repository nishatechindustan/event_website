class Event < ApplicationRecord

	attr_accessor :category_ids
	attr_accessor :artist_ids
	attr_accessor :event_location
	attr_accessor :event_dates

	validates :title, presence: true
	belongs_to :user
	has_many :event_adver_dates , as: :event_adver_datable, :dependent => :destroy
	has_many :locations, as: :locatable , :dependent => :destroy
	has_many :event_categories#, dependent: :destroy
	has_many :categories, through: :event_categories
	has_many :event_artists#, dependent: :destroy
	has_many :artists, through: :event_artists
	has_many :attachments, as: :attachable, dependent: :destroy
	validates_presence_of :category_ids_present?
	validates_presence_of :artist_ids_present?

	after_save :remove_add_categories, :if => lambda {|obj| obj.category_ids.present?}
	after_save :remove_add_artist, :if => lambda {|obj| obj.artist_ids.present?}

	after_save :add_event_locations
	after_save :add_event_dates

	#use method add remove categories for the  event
	def remove_add_categories
		category_idss = category_ids.map{|a| a.to_i}
		db_category_ids = self.categories.pluck(:id)
		to_remove_category_ids = db_category_ids - category_idss
		to_add_category_ids = category_idss - db_category_ids
		if to_remove_category_ids.present?
			categories_to_remove = Category.where(id: to_remove_category_ids)
			self.categories.delete(categories_to_remove)
		end

		if to_add_category_ids.present?
			self.categories << Category.where(id: to_add_category_ids)
		end
	end

	#use methods add remove artist for the  event
	def remove_add_artist
		artist_idss = artist_ids.map{|a| a.to_i}
		db_artist_ids = self.artists.pluck(:id)
		to_remove_artist_ids = db_artist_ids - artist_idss
		to_add_artist_ids = artist_idss - db_artist_ids

		if to_remove_artist_ids.present?
			artists_to_remove = Artist.where(id: to_remove_artist_ids)
			self.artists.delete(artists_to_remove)
		end

		if to_add_artist_ids.present?
			self.artists << Artist.where(id: to_add_artist_ids)
		end
	end

	#check category are present or not in the params value or the database.
	def category_ids_present?
		if self.category_ids.present?
			db_categories = Category.where(id: self.category_ids)
			if db_categories.present?
				true
			else
				self.errors.add(:category,"not present")
			end
		else
			self.errors.add(:event," Category Can't be blank, please select at least one")
		end
	end
	#check artist are present or not in the params value or database.
	def artist_ids_present?
		if self.artist_ids.present?
			db_artist = Artist.where(id: self.artist_ids)
			if db_artist.present?
				true
			else
				self.errors.add(:category,"not present")
			end
		else
			self.errors.add(:event," Artist Can't be blank, please select at least one")
		end
	end

	#add and location for the events
	def add_event_locations
		if self.locations.present?
			event_loca =  Location.find_by(:locatable_id=> self.id, :locatable_type=>"Event")
			event_loca.update(event_location)
		else
		self.locations.create(event_location)
		end
	end

	#add date and time for the event
	def add_event_dates
		if self.event_adver_dates.present?
			even_date_time = EventAdverDate.find_by(event_adver_datable_id: self.id, event_adver_datable_type: "Event")
			even_date_time.update(event_dates)
		else
			self.event_adver_dates.create(event_dates)
		end
	end


	def self.fetch_today_event
		Event.find_by_sql("select * from events inner join event_adver_dates on events.id=event_adver_dates.event_adver_datable_id and '#{Time.zone.now.beginning_of_day}' BETWEEN event_adver_dates.start_date AND event_adver_dates.end_date").count
	end

end
