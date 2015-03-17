class EmailAddressActivationsController < ApplicationController

  include EmailAddressActivationsHelper
  
  def edit
    @activation_token = params[:id]
    @email = params[:email]
  end

  def update
    email = params[:email]

    email_address = EmailAddress.find_by(email: email)
    
    # must be a good email address
    if !email_address
      put_flash(FlashMessages::MISSING_EMAIL)
      redirect_to root_url and return
    end

    activation_token = params[:activation_token]
    
    # validate the password before giving anything else away
    if !email_address.user.authenticate(params[:activation][:password])
      put_flash(FlashMessages::INCORRECT_PASSWORD)
      redirect_to action: "edit", activation_token: activation_token, email: email and return
    end

    if !email_address.activated && email_address.authenticated?(activation_token)
      email_address.update_attributes({ activated: true, activated_at: Time.zone.now })
      log_in email_address.user
      put_flash(FlashMessages::SUCCESS)
      redirect_to settings_email_identities_path
    else
      put_flash(FlashMessages::INVALID_TOKEN)
      redirect_to root_url
    end
  end

end
