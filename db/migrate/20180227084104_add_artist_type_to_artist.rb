class AddArtistTypeToArtist < ActiveRecord::Migration[5.1]
  def change
    add_column :artists, :artist_type, :string
  end
end
