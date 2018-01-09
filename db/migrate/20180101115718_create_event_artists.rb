class CreateEventArtists < ActiveRecord::Migration[5.1]
  def change
    create_table :event_artists , id: false do |t|
      t.integer :event_id
      t.integer :artist_id
   
    end
  end
end
