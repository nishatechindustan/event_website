class CreateAttachments < ActiveRecord::Migration[5.1]
  def change
    create_table :attachments do |t|
		t.integer :attachable_id
		t.string  :attachable_type
		t.attachment :attachment
		t.string :image_type

		t.timestamps null: false

    end
  end
end
