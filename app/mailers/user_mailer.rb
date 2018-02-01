class UserMailer < ActionMailer::Base
 default :from => "ashish.techindustan@gmail.com"

 def registration_confirmation(user)
    @user = user
    mail(:to => "#{user.first_name} <#{user.email}>", :subject => "Registration Confirmation")
    #render :plain => {status: "success", message: " email sent"}.to_json
 end
end
