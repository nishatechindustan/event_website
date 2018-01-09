class CreateLocations < ActiveRecord::Migration[5.1]
  def change
    create_table :locations do |t|
		t.integer :locatable_id
		t.string  :locatable_type
		t.float :latitude
		t.float :longitude
		t.string :address
		t.string :venue

      t.timestamps
    end
  end
end
