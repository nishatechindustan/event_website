class CreateCustomerFeedbacks < ActiveRecord::Migration[5.1]
  def change
    create_table :customer_feedbacks do |t|
      t.string :name
      t.string :email, null: false, default: ""
      t.text :description

      t.timestamps
    end
  end
end
