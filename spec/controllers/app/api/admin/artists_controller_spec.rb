require 'rails_helper'

RSpec.describe App::Api::Admin::ArtistsController, type: :controller do
    after(:all) {
   	 FileUtils.rm_rf(Dir.glob("#{Rails.root}/public/system/*"))
    }

    let(:valid_attributes) {
	    {attachment: File.new(Rails.root + 'public/default_image.jpg') }
    }


   	describe "GET #index" do
   		context "params[:search][:value]" do 
   			before :each do
			    @ashish  = create(:artist)
		    end
   			it "searching with name" do 
			    params = { name: "Ashish" }
      			results = Artist.where(params)
  				expect(results).to match_array([@ashish])
			end
			it "searching with address" do 
			    params = { address: "mohali" }
      			results = Artist.where(params)
  				expect(results).to match_array([@ashish])
			end
			it "searching with artist type" do 
			    params = { artist_type: "dancer" }
      			results = Artist.where(params)
  				expect(results).to match_array([@ashish])
			end
  		end

  		context "without search value" do
  			it "params is not present " do
	  			ashish = FactoryBot.create(:artist, name: "ashish")	
	  			alok = FactoryBot.create(:artist, name: "alok")	
	  			sa = FactoryBot.create(:artist, name: "sa")
	  			params = {}
		        results = Artist.where('')
	            expect(results).to match_array([ashish, alok,sa])
	        end	
  		end
  	end

  	describe 'GET # create' do
	    context "with valid attributes" do

			it "#create" do
			 	advertise_params = FactoryBot.attributes_for(:artist)
			    expect { post :create, :params => { :artists => advertise_params} }.to change(Artist, :count).by(1) 
			    artist_image= Artist.first.attachments.create!(valid_attributes)
		  	end
	  	end

	  	context "with invalid attributes" do
		    it "does not save the new contact" do
		      expect{
		        post :create, :params => {:artists => {:name=>""}}
		      }.to_not change(Artist,:count)
		    end
		end
	end

	describe "#edit" do
		let!(:artist) { FactoryBot.create(:artist) }
		before(:each) do
			get :edit, :params=>{id: artist}
		end

		it "finds a specific artists" do
		 expect(response).to be_successful
		end
	end

	describe "#update" do
		let!(:artist) { FactoryBot.create(:artist) }
	    before do
	       patch 'update', params: { artists: {name: 'newmail', artist_type: 'singer' }, id: artist.id }
	    end
	    it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
	   
 	end

 	describe "GET #all artists list" do
	    before :each do
	       3.times { FactoryBot.attributes_for(:artist) }
	    end

	    it 'successfully renders the index template on GET /' do
	      expect(response).to be_successful
	    end
  	end

  	describe 'DELETE single artist #destroy' do

	    context "success" do
	      let!(:artist) { FactoryBot.create(:artist) }
	      it "deletes the artist" do
	        expect{
	          delete :destroy, :id => artist}
	          expect(response).to have_http_status(200)
	      end
	    end
  	end

  	describe 'DELETE multiple artists #destroy' do
	    context "success" do
	      let!(:artist1) { FactoryBot.create(:artist) }
	      let!(:artist2) { FactoryBot.create(:artist) }
	      it "deletes the artist" do
	        expect{
	          delete :destroy, :id => [artist1,artist2]}
	          expect(response).to have_http_status(200)
	      end
	    end
  	end

  	describe "#change_status" do
  		context "status in artist" do 
			let!(:artist) { FactoryBot.create(:artist) }
		    it 'update status of the specific artist if true' do
		    	results = Artist.changeStatus(artist)
	        	expect(response).to have_http_status(200)
	      	end
	    end

	    context "status in artist" do 
	    	artist  = Artist.create(:name=> "ashish", :status=>false)
		    it 'update status of the specific artist if artist is false' do
		    	results = Artist.changeStatus(artist)
	        	expect(response).to have_http_status(200)
	      	end
	    end
 	end
end
