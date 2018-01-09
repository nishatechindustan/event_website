class CreateEventAdverDates < ActiveRecord::Migration[5.1]
  def change
    create_table :event_adver_dates do |t|
    	t.integer :event_adver_datable_id
		t.string  :event_adver_datable_type
		t.date :start_date
		t.date :end_date
		t.time :start_time
		t.time :end_time

      t.timestamps
    end
  end
end
