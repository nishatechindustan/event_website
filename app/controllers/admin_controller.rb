class AdminController < ApplicationController
#layout 'admin'
 # before_action :authorized?

  private
  def authorized?
  	if user_signed_in?
	    unless current_user.is_admin?
	      flash[:notice] = "You are not authorized to view that page."
	      render :json=>{:notice=> "You are not authorized to view that page.", :status=> false}
	    end
	else
    render :json =>{:notice=>"Please login first for access this page", :status=>false }
	end
  end
end
