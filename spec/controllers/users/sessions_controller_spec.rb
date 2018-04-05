require 'rails_helper'
require 'spec_helper'
require 'devise/test_helpers'

RSpec.describe Users::SessionsController, type: :controller do
	let(:user) { create(:user) }
  # Mock `Authorization` header
  let(:header) { { 'Authorization' => token_generator(user.id) } }
  # Invalid request subject
  subject(:invalid_request_obj) { described_class.new({}) }
  # Valid request subject
  subject(:request_obj) { described_class.new(header) }
	before(:each) do
		setup_controller_for_warden
  		request.env["devise.mapping"] = Devise.mappings[:user]
	end
  	it "should sign the user in" do
  		expect(warden.authenticated?(:user)== true)
	end
end
