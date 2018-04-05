require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :controller do
	let(:user) { build(:user) }
  let(:headers) { valid_headers.except('Authorization') }
  let(:valid_attributes) do
    attributes_for(:user, password_confirmation: user.password)
  end

  # User signup test suite
  	describe 'POST /signup' do
    # context 'when valid request' do
    #   before { post '/create', params: valid_attributes}

    #   it 'creates a new user' do
    #     expect(response).to have_http_status(201)
    #   end
	    it "#create" do
			expect { post :users, :params => { :registration => valid_attributes}}
		end

    end

    context 'when invalid request' do
    	it "invalid  request" do
     		expect { post :users, :params => { :registration => {}} }
    	end
  	end
end
