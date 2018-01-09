class CreateArtists < ActiveRecord::Migration[5.1]
  def change
    create_table :artists do |t|
      t.string :name
      t.boolean :status , default: true
      t.string :address
      t.text :description

      t.timestamps
    end
  end
end
