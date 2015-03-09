class SessionsController < ApplicationController
  def create
    # find the email address
    email_address = EmailAddress.find_by(email: params[:session][:email])
    if email_address.nil?
      flash.now[:danger] = 'bad email'
      render 'new'
    else
      # authenticate the user
      if email_address.user.authenticate(params[:session][:password])
        log_in email_address.user
        redirect_to request.referrer || root_url
      else
        flash.now[:danger] = 'bad password'
        render 'new'
      end
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end
end
