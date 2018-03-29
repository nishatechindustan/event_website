class CreateAdvertises < ActiveRecord::Migration[5.1]
  def change
    create_table :advertises do |t|
      t.string :organization_name
      t.string :contact_person
      t.string :contact_number
      t.string :event_type
      t.timestamps
    end
  end
end
