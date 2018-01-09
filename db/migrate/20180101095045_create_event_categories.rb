class CreateEventCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :event_categories , id: false do |t|
      t.integer :event_id
      t.integer :category_id

    end
  end
end
 	