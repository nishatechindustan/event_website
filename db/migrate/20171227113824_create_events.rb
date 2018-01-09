class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
    	t.string :title
    	t.text :description
    	t.string :ticket_available
    	t.integer :cost
    	t.string :currency
    	t.string :contact_number
    	t.string :cost_offers
    	t.string :email
        t.string :event_type
        t.references :user
        t.boolean :status ,default: true

      t.timestamps
    end
  end
end
