require 'test_helper'

class Settings::GeneralsControllerTest < ActionController::TestCase

  include Settings::GeneralsHelper

  def setup
    @user = User.create!(name: "Stu", password: "test123", password_confirmation: "test123")
    @email_address = @user.email_addresses.create!(email: "hello@world.org")
    @user.primary_email_address_id = @email_address.id
    @user.save!
    log_in @user
  end

  #
  # show tests
  #

  test "show when logged in should render show" do
    get_show
    assert_template :show
  end

  test "show when not logged in should redirect to root" do
    log_out
    get_show
    assert_redirected_with_flash [FlashMessages::NOT_LOGGED_IN], root_url
  end

  #
  # update tests
  #

  test "missing password should alert" do
    patch_update "test123", nil, nil
    assert_rendered_with_flash [FlashMessages::PASSWORD_BLANK], :show

    patch_update "test123", "    ", "    "
    assert_rendered_with_flash [FlashMessages::PASSWORD_BLANK], :show
  end

  test "incorrect current password should alert" do
    patch_update nil, "test321", "test321"
    assert_rendered_with_flash [FlashMessages::PASSWORD_INCORRECT], :show

    patch_update "wrong-password", "test321", "test321"
    assert_rendered_with_flash [FlashMessages::PASSWORD_INCORRECT], :show
  end

  test "update with valid params should update password" do
    patch_update "test123", "test321", "test321"
    assert @user.reload.authenticate("test321"), "password should be changed"
    assert_redirected_with_flash [FlashMessages::SUCCESS], settings_general_path
  end

  test "update when logged out should redirect to root" do
    log_out
    patch_update "test123", "test321", "test321"
    assert_redirected_with_flash [FlashMessages::NOT_LOGGED_IN], root_url
  end
  
  private

  def get_show
    get :show
  end

  def patch_update(current_password, password, password_confirmation)
    patch :update, change_password: { current_password: current_password,
                                      password: password,
                                      password_confirmation: password_confirmation }
  end
end
