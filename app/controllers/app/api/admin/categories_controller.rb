class App::Api::Admin::CategoriesController < AdminController

	#callbacks
	before_action :get_category, only: [:edit, :show, :update,:destroy]

	#show all category
	def index
		@categories =  Category.all
		render :json => {:data=>@categories, :status=>true}
	end



	#add new catagory
	def create
		 @category = Category.new(name: params[:name])
		 if @category.save
			 render :json => {:status=>true, :message=> "category has been created successfully", :data => @category}
		 else
			 render :json => {:status=>false, :data=> @category.errors.full_messages}
		 end
	end

	# delete category
	def destroy
		if @category.destroy
			render :json => {:status=> true, :messages=> "Category has been Deleted successfully.", :data => @category}
		else
			render :json => {:status=> false, :messages=> @category.errors.full_messages}
		end
	end

	# update category with according to id
	def update
		response = {}
		if @category.update(:name => params[:name])
			response =  {:message =>"category update successfully", :status=> true}
		else
			response = {:message=> @category.errors.full_messages,  :status=> false}
		end
		render :json =>response
	end

	#show only one category using category id
	def show
	end


	private

	# callback use for get category  id before call edit, show, destroy, update
	def get_category
		@category = Category.find params[:id]
	end
end
