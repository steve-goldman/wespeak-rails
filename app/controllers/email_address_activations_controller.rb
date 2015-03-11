class EmailAddressActivationsController < ApplicationController

  def edit
    @activation_token = params[:id]
    @email = params[:email]
  end

  def update
    email = params[:email]

    email_address = EmailAddress.find_by(email: email)
    
    # must be a good email address
    if !email_address
      flash[:danger] = "Invalid activation link"
      redirect_to root_url and return
    end

    activation_token = params[:activation_token]
    
    # validate the password before giving anything else away
    if !email_address.user.authenticate(params[:activation][:password])
      flash[:danger] = "Incorrect password"
      redirect_to action: "edit", activation_token: activation_token, email: email and return
    end

    if !email_address.activated && email_address.authenticated?(activation_token)
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
