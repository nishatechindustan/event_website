class Artist < ApplicationRecord
	has_many :locations
	validates :name, presence: true
	has_many :attachments, as: :attachable, dependent: :destroy
	has_many :event_artists#, dependent: :destroy
	has_many :events, through: :event_artists

	def self.changeStatus(artist)
    	if artist.status==true
    		artist.update(:status=>false)
            message = "Artist has been Deactivate successfully"
    	else
    		artist.update(:status=>true)
            message = "Artist has been Activate successfully"
    	end

    	return {:status=>true, :message=>message}
    end
end