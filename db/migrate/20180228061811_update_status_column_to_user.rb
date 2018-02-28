class UpdateStatusColumnToUser < ActiveRecord::Migration[5.1]
	def up
		change_column :users, :status, :boolean, default: true
		User.update_all(:status =>true)
	end

	def down
		change_column :users, :status, :boolean, default: nil
	end
end
