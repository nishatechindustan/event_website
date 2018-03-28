class SubscriptionController < ApplicationController

	def news_letter_subscription
		if !params[:email].blank?
			@list_id = "4fb9e5ef0c"
        gb = Gibbon::Request.new
            begin	
                response = gb.lists(@list_id).members.create(body: {email_address: params[:email], status: "subscribed" })
                if response.body["status"] = "subscribed"
                    message = "congratulations you have sucessfully Signed Up for news letter"
                    type = 'success'
                end
            rescue Gibbon::MailChimpError => e
                if e.body['title'] == "Member Exists"
                    message = "#{params[:email]} is already signed up for news-letter"
                    type = 'error'
                else
                    message = e.body["detail"]
                    type = 'error'
                end	
                        
            end
		else
			message	= "email can't be blank" 
			type = 'error'
		end	
		render :json =>{message: message, type: type, status: 200}
	end
end

