require 'test_helper'

class EmailAddressActivationsControllerTest < ActionController::TestCase

  include EmailAddressActivationsHelper

  def setup
    @user = User.create!(name: "Stu", password: "test123", password_confirmation: "test123")
    @email_address = @user.email_addresses.create!(email: "hello@world.com")
  end

  #
  # edit tests
  #
  
  test "missing email in edit should redirect to root" do
    get_edit @email_address.activation_token, nil
    assert_redirected_with_flash [FlashMessages::EMAIL_MISSING], root_url
  end

  test "unknown email in edit should redirect to root" do
    get_edit @email_address.activation_token, "unknown@email.addr"
    assert_redirected_with_flash [FlashMessages::EMAIL_UNKNOWN], root_url
  end

  test "active email in edit should redirect to root" do
    @email_address.update_attribute(:activated, true)
    get_edit @email_address.activation_token, @email_address.email
    assert_redirected_with_flash [FlashMessages::EMAIL_ALREADY_ACTIVE], root_url
  end

  test "valid params in edit should render edit" do
    get_edit @email_address.activation_token, @email_address.email
    assert_template :edit
  end

  #
  # update tests
  #
  
  test "missing email in update should redirect to root" do
    submit_update @email_address.activation_token, nil, @user.password
    assert_redirected_with_flash [FlashMessages::EMAIL_MISSING], root_url
  end

  test "unknown email in update should redirect to root" do
    submit_update @email_address.activation_token, "unknown@email.addr", @user.password
    assert_redirected_with_flash [FlashMessages::EMAIL_UNKNOWN], root_url
  end

  test "active email in update should redirect to root" do
    @email_address.update_attribute(:activated, true)
    submit_update @email_address.activation_token, @email_address.email, @user.password
    assert_redirected_with_flash [FlashMessages::EMAIL_ALREADY_ACTIVE], root_url
  end

  test "incorrect token should redirect to root" do
    submit_update "wrong-token", @email_address.email, @user.password
    assert_redirected_with_flash [FlashMessages::TOKEN_INVALID], root_url
  end

  test "missing password should render edit" do
    submit_update @email_address.activation_token, @email_address.email, nil
    assert_redirected_with_flash [FlashMessages::PASSWORD_MISSING], root_url
  end

  test "incorrect password should render edit" do
    submit_update @email_address.activation_token, @email_address.email, "wrong-password"
    assert_redirected_with_flash [FlashMessages::PASSWORD_INCORRECT], root_url
  end

  test "successful submission should activate, log in, and redirect to settings/email_identities" do
    submit_update @email_address.activation_token, @email_address.email, @user.password
    assert @email_address.reload.activated?, "email address should be activated"
    assert_logged_in_as @user
    assert_redirected_with_flash [FlashMessages::SUCCESS], settings_email_identities_path
  end
  
  private

  def get_edit(id, email)
    get :edit, id: id, email: email
  end

  def submit_update(id, email, password)
    patch :update, id: id, email: email, activation: { password: password }
  end
end
