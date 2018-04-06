require 'rails_helper'

RSpec.describe App::Api::Admin::EventsController, type: :controller do
  let(:valid_attr) { attributes_for(:event)}
  let(:location_params) { attributes_for(:location)}
  let(:eventdate_params) { attributes_for(:event_adver_date)}
  after(:all) {
   FileUtils.rm_rf(Dir.glob("#{Rails.root}/public/system/*"))
  }

  let(:valid_attributes) {
      {attachment: File.new(Rails.root + 'public/default_image.jpg') }
  }
  before(:each) do
      sign_in_as_a_valid_user
      create_new_event
      allow(controller).to receive(:authenticate_request!).and_return(true)
  end

  describe "GET 'all events details list '" do
    before :each do
      @event = Event.all
    end
    it "returns http success" do
      get 'index'
      expect(response).to be_successful
    end
  end

  describe 'GET # create' do
    context "with valid attributes" do

    it "#create" do
        expect { post :create, :params => { :event => valid_attr, :location=>location_params, :category_ids=>@category.id, :artist_ids=>@artist.id}}
      end
    end

    context "with invalid attributes" do
      it "does not save the new contact" do
        expect{
          post :create, :params => {:event => {:title=>""}}
        }.to_not change(Event,:count)
      end
    end
  end

  describe "#update" do
    context 'with valid attributes' do
      it 'should update the event' do
        process :update, method: :put, params: { id: @event.id, event: attributes_for(:event), :location=>location_params, :event_date=>eventdate_params }
        @event.reload
        expect(response).to have_http_status(200)
      end
    end
  end

  describe '#delete user' do
    it 'should delete an event' do
      expect{
        delete :destroy, :params=>{id: @event}
      }.to change{ Event.count }.from(1).to(0)
    end
  end

  describe "#show" do 
    it "returns event details" do 

      get :show, :params=>{id: @event.id }

      expect(response.status).to eq 200
    end
  end

  describe "#change_status" do
    context "status in event" do 
      it 'update status of the specific event if true' do
        results = Event.changeStatus(@event)
          expect(response).to have_http_status(200)
      end
      it 'update status of the specific artist if artist is false' do
        results = Event.changeStatus(@event)
          expect(response).to have_http_status(200)
      end
    end
  end

  describe "GET 'all events details according to user '" do
    it "returns http success" do
      get_auth_token
       params = {:length=>10}
       
       # @event = Event.evnt_list(params, @user)
       # ,headers:  {"access-token" => ''}
        # get 'get_event_list', :headers=> {"Authorization" => request.headers['Authorization']}
       expect(response).to be_successful
    end
  end

  describe "GET 'latest events details '" do
    it "returns http success" do
      get_auth_token
       params = {:length=>10}
       post 'latest_event'
       expect(response).to be_successful
    end
  end

  describe "GET 'unapprove events details '" do
    it "returns http success" do
      get_auth_token
       params = {:length=>10}
       post 'unapprove_event'
       expect(response).to be_successful
    end
  end
  

  describe "GET 'event_list  details '" do
    context "if event type are present" do
      it "returns http success" do
        get_auth_token
         params = {:length=>10}
         post 'event_list', :params=>{:event_type=>"passed"}
         events = Event.passed_event(params)
         expect(response).to be_successful
      end
    end
    # context "if event type are not present" do
    #   it "returns http success" do
    #     get_auth_token
    #      params = {:length=>10}
    #       headers = { "CONTENT_TYPE" => "application/json" }
    #      post 'event_list', :params=>{:event_type=>''}, :headers => headers
    #      # events= Event.evnt_list(params,@user)
    #      expect(response).to be_successful
    #   end
    # end
  end
end
