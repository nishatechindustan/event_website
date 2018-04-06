class EventMailer < ApplicationMailer
	def event_approval_notification(event)
	    user = event.user
	    mail(:to => user.email, :subject => "Event review testing ")
    #render :plain => {status: "success", message: " email sent"}.to_json
 	end
end
