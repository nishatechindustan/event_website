module Api::V1::Web
	class ContactsController < ApiController

		def index
			contacts = Contact.all
			response = {:status=>true, :data=>contacts}
			json_response(response)	
		end

		def create
			response ={:status=> false, :message=> "Please check all the  details"}
			if(params[:first_name].present? && params[:last_name].present? && params[:email].present?)
				contact = Contact.new(:first_name=>params[:first_name],:last_name=>params[:last_name], :email=>params[:email], :description=>params[:description])
				if contact.save
					response = {:status=>true,:message=>"Your request has been successfully sent."}
				else
					response = {:status=>false, :errors=>contact.errors.full_messages}
				end
			end
			json_response(response)
		end

		def customer_feedback
			response ={:status=> false, :message=> "Please check all the  details"}
			if(params[:name].present? && params[:email].present?)
				customer_feedback = CustomerFeedback.new(:name=>params[:name],:email=>params[:email], :description=>params[:description])
				if customer_feedback.save
					response = {:status=>true,:message=>"Your request has been successfully sent."}
				else
					response = {:status=>false, :errors=>customer_feedback.errors.full_messages}
				end
			end
			json_response(response)
		end
	end
end