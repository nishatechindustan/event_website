class Admin::CategoriesController < AdminController

	before_action :get_category, only: [:edit, :show, :update,:destroy]

	#show all category
	def index
		@categories =  Category.all
	end

	#initialize category
	def new
		@category = Category.new
	end

	#add new catagory
	def create
		@category = Category.new(category_params)

		if @category.save
			flash[:notice] = "category has been created successfully."
			redirect_to admin_categories_path
		else
			flash[:errors] = @category.errors.full_messages
			#render "new"
			redirect_to new_admin_category_path
		end
	end

	#edit category
	def edit
		
	end

	# delete category
	def destroy
		if @category.destroy
			flash[:notice] = "Category has been deleted successfully"
			redirect_to admin_categories_path
		else
			flash[:errors] = @category.errors.full_messages
			redirect_to admin_categories_path
		end
	end

	# update category with according to id
	def update
		if @category.update(:name => params[:name])
			flash[:notice] =  "category has been updated sccessfully."
			redirect_to edit_admin_category_path(@category)
		else
			flash[:errors] = @category.errors.full_messages
			redirect_to edit_admin_category_path(@category)
		end
	end
	
	#show only one category using category id
	def show
	end

	private

	# callback use for get category  id before call edit, show, destroy, update
	def get_category
		@category = Category.find params[:id]
		
	end
	
	#using strong paramter for saved records
	def category_params
		params.require(:category).permit(:name)
	end

end
