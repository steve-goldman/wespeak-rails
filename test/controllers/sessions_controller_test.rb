require 'test_helper'

class SessionsControllerTest < ActionController::TestCase

  include SessionsHelper

  def setup
    @user = User.new(name: "Stu", password: "test123", password_confirmation: "test123")
    @user.save!
    @email_address1 = @user.email_addresses.create(email: "hello@world.org",   activated: true)
    @email_address2 = @user.email_addresses.create(email: "goodbye@world.org", activated: true)
    @email_address3 = @user.email_addresses.create(email: "howdie@world.org",  activated: false)
  end

  #
  # new tests
  #
  
  test "new should render new" do
    get_new
    assert_template :new
  end

  test "new when logged in should redirect to root" do
    log_in @user
    get_new
    assert_redirected_with_flash [FlashMessages::LOGGED_IN], root_url
  end


  #
  # create tests
  #

  test "create with inactive email address should not log in" do
    post_create @email_address3.email, @user.password
    assert !logged_in?
    assert_rendered_with_flash [FlashMessages::EMAIL_NOT_ACTIVATED], :new
  end
  
  test "create with unknown email address should not log in" do
    post_create "unknown@email.addr", @user.password
    assert !logged_in?
    assert_rendered_with_flash [FlashMessages::INVALID_EMAIL_OR_PASSWORD], :new

    post_create "     ", @user.password
    assert !logged_in?
    assert_rendered_with_flash [FlashMessages::INVALID_EMAIL_OR_PASSWORD], :new
  end

  test "create with incorrect password should not log in" do
    post_create @email_address1.email, "wrong-password"
    assert !logged_in?
    assert_rendered_with_flash [FlashMessages::INVALID_EMAIL_OR_PASSWORD], :new

    post_create @email_address1.email, nil
    assert !logged_in?
    assert_rendered_with_flash [FlashMessages::INVALID_EMAIL_OR_PASSWORD], :new

    post_create @email_address1.email, "    "
    assert !logged_in?
    assert_rendered_with_flash [FlashMessages::INVALID_EMAIL_OR_PASSWORD], :new
  end
  
  test "create with valid params should log in" do
    post_create @email_address1.email, @user.password, '0'
    assert_flash []
    assert_equal current_user, @user
    assert_nil cookies[:user_id]
    assert_nil cookies[:remember_token]
    assert_redirected_to root_url

    log_out
    assert !logged_in?

    post_create @email_address2.email, @user.password, '1'
    assert_flash []
    @user.reload
    assert_equal current_user, @user
    assert_equal @user.id, cookies.signed[:user_id]
    assert @user.remember_authenticated?(cookies[:remember_token])
    assert_redirected_to root_url
  end

  #
  # destroy tests
  #

  test "log out when logged in should log out" do
    log_in @user
    delete_destroy
    assert !logged_in?
    assert_redirected_to root_url
  end

  test "log out when not logged in should not throw" do
    delete_destroy
    assert !logged_in?
    assert_redirected_to root_url
  end
  
  private

  def get_new
    get :new
  end

  def post_create(email, password, remember_me = '1')
    post :create, session: { email: email, password: password, remember_me: remember_me }
  end

  def delete_destroy
    delete :destroy
  end
end
