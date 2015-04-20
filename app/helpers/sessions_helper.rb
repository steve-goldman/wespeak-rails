module SessionsHelper

  include ApplicationHelper

  # logs in a user
  def log_in(user)
    session[:user_id] = user.id
  end

  # remember the user in a persistent session
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # forget the user in a persistent session
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # current logged-in user (if any)
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: session[:user_id])
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.remember_authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # bool for whether a user is logged in
  def logged_in?
    !current_user.nil?
  end

  # logs out the current user
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  class FlashMessages
    LOGGED_IN                 = FlashMessage.new(:info,     "You must be logged out to view this page")

    EMAIL_NOT_ACTIVATED       = FlashMessage.new(:warning,  "Email address not activated (check email for the activation link)")

    INVALID_LOGIN_OR_PASSWORD = FlashMessage.new(:danger,   "Invalid login or password")
  end

end
