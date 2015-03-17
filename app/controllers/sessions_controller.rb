class SessionsController < ApplicationController
  def create
    # find the email address
    email_address = EmailAddress.find_by(email: params[:session][:email].downcase)
    if email_address.nil?
      put_flash_now(FlashMessages::INVALID_EMAIL_OR_PASSWORD)
      render 'new'
    else
      # authenticate the user
      if email_address.user.authenticate(params[:session][:password])
        if email_address.activated?
          log_in email_address.user
          params[:session][:remember_me] == '1' ?
            remember(email_address.user) : forget(email_address.user)
          redirect_to root_url
        else
          put_flash(FlashMessages::EMAIL_NOT_ACTIVATED)
          redirect_to root_url
        end
      else
        put_flash(FlashMessages::INVALID_EMAIL_OR_PASSWORD)
        render 'new'
      end
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
