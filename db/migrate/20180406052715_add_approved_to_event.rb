class AddApprovedToEvent < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :approved, :boolean, default: false
  end
end
