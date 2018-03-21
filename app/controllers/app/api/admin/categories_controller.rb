class App::Api::Admin::CategoriesController < AdminController

	#callbacks
	before_action :get_category, only: [:edit, :show, :update,:destroy,:change_status]

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
			render :json => {:status=>false, :errors=> @category.errors.full_messages}
		end
	end

	# delete category
	def destroy
		if @category.destroy
			render :json => {:status=> true, :message=> "Category has been Deleted successfully.", :data => @category}
		else
			render :json => {:status=> false, :errors=> @category.errors.full_messages}
		end
	end


	def edit
		if @category.present?
	      category = {:name=> @category.name,:id=> @category.id}
	      response = {:status=> true, :data=> category}
	    else
	      response = {:status=> false, :message=> "something went wrong"}
	    end
	    render :json=> response
	end

	# update category with according to id
	def update
		response = {}
		if @category.update(:name => params[:name])
			response =  {:message =>"category update successfully", :status=> true}
		else
			response = {:errors=> @category.errors.full_messages,  :status=> false}
		end
		render :json =>response
	end

	#show only one category using category id
	def show
	end

	def get_category_list
		categories= []
	    recordsTotal = Category.all.count
	    search_value = params[:search][:value]
	    
	    if search_value.present?
	      @categories = Category.where('name ILIKE ?', "%#{search_value}%").order(sort_column + " " + sort_direction).limit(params[:length].to_i).offset(params[:start].to_i)
	      recordsFiltered = @categories.count
	    else
	      @categories = Category.all.order(sort_column + " " + sort_direction).limit(params[:length].to_i).offset(params[:start].to_i)
	      
	      recordsFiltered = recordsTotal
	    end

	    @categories.each do |category|
	      categories<<{:id=>category.id, :name=>category.name, :status=>category.status}
	    end
	    render :json => {:data=>categories, :status=>true ,:draw=>params[:draw], :recordsTotal=>recordsTotal, :recordsFiltered=>recordsFiltered}
	end

	def change_status
		response = Category.changeStatus(@category)
		render :json=>response
	end

	def delete_categories
		@categories = Category.where(:id=> params[:category_ids])
		if @categories.destroy_all
			render :json => {:status=> true, :message=> "Category has been Deleted successfully."}
		end
	end


	private

	# callback use for get category  id before call edit, show, destroy, update
	def get_category
		@category = Category.find params[:id]
	end
	
	def sort_column
		# column_value  = params[:order].first[:column]
  #   	params[:order].first[:dir]
    	column_value  = params[:order]["0"][:column]
    	case column_value
   		when 1
    		"name"
    	when 2
      		"status"
      	else
      		"created_at"
   		end   
	end

 	def sort_direction
    	params[:order]["0"][:dir]
  	end
end
