class EmailAddressActivationsController < ApplicationController

  def edit
    email_address = EmailAddress.find_by(email: params[:email])
    if email_address && !email_address.activated && email_address.authenticated?(params[:id])
      email_address.update_attributes({ activated: true, activated_at: Time.zone.now })
      log_in email_address.user
      flash[:success] = "Email address activated!"
      redirect_to root_url
    else
      flash[:danger] = "Invalid activation link"
      redirect_to root_url
    end
  end

end
