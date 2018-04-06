require 'rails_helper'

RSpec.describe App::Api::Admin::UsersController, type: :controller do
	after(:all) {
   	 FileUtils.rm_rf(Dir.glob("#{Rails.root}/public/system/*"))
    }

    let(:valid_attributes) {
	    {attachment: File.new(Rails.root + 'public/default_image.jpg') }
    }
  let(:valid_attr) { attributes_for(:event)}
  let(:location_params) { attributes_for(:location)}
  let(:eventdate_params) { attributes_for(:event_adver_date)}

	before do
		sign_in_as_a_valid_user
		create_new_event
		allow(controller).to receive(:authenticate_request!).and_return(true)
   end

  describe "GET 'all_users details list '" do
    before :each do
      @user = (User.all - [User.last]).count
    end
    it "returns http success" do
      get 'all_users'
      expect(response).to be_successful
    end
  end

  describe "#edit" do
		before(:each) do
			get :edit, :params=>{id: @user}
		end

		it "finds a specific user" do
		 expect(response).to be_successful
		end
	end

	describe "#show" do 
	  it "returns user details" do 

      get :show, :params=>{id: @user.id }

      expect(response.status).to eq 200
    end
  end

  describe '#delete user' do

	  it 'should delete an user' do
	    expect{
	      delete :delete_user, :params=>{id: @user}
	    }.to change{ User.count }.from(1).to(0)
	  end
	end

	describe "#change_status" do
  		context "status in user" do 
		    it 'update status of the specific artist if true' do
		    	results = User.changeStatus(@user)
	        	expect(response).to have_http_status(200)
	      	end
	    end

	    context "status in artist" do 
	    	before do
	    		@user1=create(:user, :status=>false, :email=>"testing@gmail.com")
	    	end
		    it 'update status of the specific artist if artist is false' do
		    	results = User.changeStatus(@user1)
	        	expect(response).to have_http_status(200)
	      	end
	    end
 	end

 	describe "#update" do
 	  context 'with valid attributes' do
	    it 'should update the user' do
	      process :update, method: :put, params: { id: @user.id, user: attributes_for(:user, :email=>"as@gmail.com") }
	      @user.events.reload
	      expect(response).to have_http_status(200)
	    end
  	end
  end

  describe "GET #get_users_list" do
 		context "params[:search][:value]" do 
 			it "searching with name" do 
		    params = { user_name: "A" }
    			results = User.where(params)
				expect(results).to match_array([@user])
			end
			it "searching with first_name" do 
			    params = { first_name: "Ashish" }
      			results = User.where(params)
  				expect(results).to match_array([@user])
			end
		end

		context "without search value" do
			it "params is not present " do
  			params = {}
	        results = User.where('')
            expect(results).to match_array([@user])
        end	
		end
	end
end
