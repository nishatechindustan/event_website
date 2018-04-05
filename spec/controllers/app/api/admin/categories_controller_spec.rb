require 'rails_helper'

RSpec.describe App::Api::Admin::CategoriesController, type: :controller do
	describe "GET #index" do
   		context "params[:search][:value]" do 
   			before :each do
			    @ashish  = create(:category)
		    end
   			it "searching with name" do 
			    params = { name: "testing" }
      			results = Category.where(params)
  				expect(results).to match_array([@ashish])
			end
  		end

  		context "without search value" do
  			it "params is not present " do
	  			ashish = FactoryBot.create(:category, name: "ashish")	
	  			alok = FactoryBot.create(:category, name: "alok")	
	  			sa = FactoryBot.create(:category, name: "sa")
	  			params = {}
		        results = Category.where('')
	            expect(results).to match_array([ashish, alok,sa])
	        end	
  		end
  	end

  	describe 'GET # create' do
	    context "with valid attributes" do

			it "#create" do
			 	category_params = FactoryBot.attributes_for(:category)
			    expect { post :create, :params => { :category => category_params} } 
		  	end
	  	end

	  	context "with invalid attributes" do
		    it "does not save the new contact" do
		      expect{
		        post :create, :params => {:category => {:name=>""}}
		      }.to_not change(Category,:count)
		    end
		end
	end

	describe "#edit" do
		let!(:category) { FactoryBot.create(:category) }
		before(:each) do
			get :edit, :params=>{id: category}
		end

		it "finds a specific categories" do
		 expect(response).to be_successful
		end
	end

	describe "#update" do
		let!(:category) { FactoryBot.create(:category) }
	    before do
	       patch 'update', params: { categories: {name: 'newmail'}, id: category.id }
	    end
	    it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
	   
 	end

 	describe "GET #all categories list" do
	    before :each do
	       3.times { FactoryBot.attributes_for(:category) }
	    end

	    it 'successfully renders the index template on GET /' do
	      expect(response).to be_successful
	    end
  	end

  	describe 'DELETE single category #destroy' do

	    context "success" do
	      let!(:category) { FactoryBot.create(:category) }
	      it "deletes the category" do
	        expect{
	          delete :destroy, :id => category}
	          expect(response).to have_http_status(200)
	      end
	    end
  	end

  	describe 'DELETE multiple category #destroy' do
	    context "success" do
	      let!(:category1) { FactoryBot.create(:category) }
	      let!(:category2) { FactoryBot.create(:category, :name=> 'alok') }
	      it "deletes the category" do
	        expect{
	          delete :destroy, :id => [category1,category2]}
	          expect(response).to have_http_status(200)
	      end
	    end
  	end

  	describe "#change_status" do
  		context "status in category" do 
			let!(:category) { FactoryBot.create(:category) }
		    it 'update status of the specific category if true' do
		    	results = Category.changeStatus(category)
	        	expect(response).to have_http_status(200)
	      	end
	    end

	    context "status in category" do 
	    	category  = Category.create(:name=> "ashish", :status=>false)
		    it 'update status of the specific category if category is false' do
		    	results = Category.changeStatus(category)
	        	expect(response).to have_http_status(200)
	      	end
	    end
 	end
end
