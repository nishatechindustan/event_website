class AdminController < ApplicationController
layout 'admin'
 before_action :authorized?
  
  private
  def authorized?
  	if user_signed_in?
	    unless current_user.is_admin?
	      flash[:notice] = "You are not authorized to view that page."
	      redirect_to root_path
	    end
	else
		flash[:notice] = "Please login first for access this page"
		redirect_to new_user_session_path
	end
  end
end