class ConfirmationsController < Devise::ConfirmationsController

	# private
	# def after_confirmation_path_for(resource_name, resource)
	# 	new_user_session_path
	# end
  def show
    user = User.find_by(:confirmation_token =>params[:confirmation_token])
    if user.present? && user.confirmed_at.blank?
      user.update_columns(:confirmed_at=>Time.now)
      render :json => {:status=> true, :message=> "Email has been confirmed"}
    elsif user.present? && user.confirmed_at.present?
      render :json => {:status=> true, :message=> "Email has been already confirmed"}

    else
      render :json=> {:status=> false,:message=> "Envalid  conformation Token "}
    end
  end
end
