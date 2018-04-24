class ConfirmationsController < Devise::ConfirmationsController

  def show
    user = User.find_by(:confirmation_token =>params[:confirmation_token])
    if user.present? && user.confirmed_at.blank?
      user.update_columns(:confirmed_at=>Time.now)
      flash[:message] = "Email has been confirmed."
      # render :json => {:status=> true, :message=> "Email has been confirmed"}
    elsif user.present? && user.confirmed_at.present?
      # render :json => {:status=> true, :message=> "Email has been already confirmed"}
     flash[:notice] = "Email has been already confirmed."
    else
      flash[:notice] = "Envalid confirmation Token."
    end
    redirect_to root_path and return
  end
end

