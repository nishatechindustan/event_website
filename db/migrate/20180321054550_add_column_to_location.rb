class AddColumnToLocation < ActiveRecord::Migration[5.1]
  def change
  	add_column :locations, :city, :string
  	add_column :locations, :state, :string
  	add_column :locations, :country, :string
  end
end
