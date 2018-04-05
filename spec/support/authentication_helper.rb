module AuthenticationHelper
  	def sign_in_as_a_valid_user
      @user ||= FactoryBot.create(:user)
       # set_cookie "authentication_token=#{@user.authentication_token}"
      @user ||= FactoryBot.create(:user)
      token =  JsonWebToken.encode({user_id: @user.id})
      request.headers['Authorization'] = token
    end
    # JsonWebToken.decode(token)
    def get_auth_token
    	@user ||= FactoryBot.create(:user)
    	token =  JsonWebToken.encode({user_id: @user.id})
      headers={}
	    request.headers['Authorization'] = token
      headers.merge!('HTTP_ACCESS_TOKEN' => token)
      headers.merge!('Authorization' => token)
  	end
end

RSpec.configure do |config|
  config.include AuthenticationHelper, :type=>:controller
end