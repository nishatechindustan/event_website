class Category < ApplicationRecord
	validates :name, presence: true, uniqueness: true
  has_many :event_categories#, dependent: :destroy
	has_many :events, through: :event_categories, dependent: :destroy

	def self.changeStatus(category)
  	if category.status==true
  		category.update(:status=>false)
      message = "Category has been Deactivate successfully"
  	else
  		category.update(:status=>true)
      message = "Category has been Activate successfully"
  	end

  	return {:status=>true, :message=>message}
  end
end
