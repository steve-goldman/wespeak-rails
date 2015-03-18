require 'test_helper'

class Settings::EmailIdentitiesControllerTest < ActionController::TestCase

  include Settings::EmailIdentitiesHelper

  def setup
    @user = User.new(name: "Stu", password: "test123", password_confirmation: "test123")
    @user.save!
    @email_address1 = @user.email_addresses.create(email: "hello@world.org",   activated: true, activated_at: Time.zone.now)
    @email_address2 = @user.email_addresses.create(email: "goodbye@world.org", activated: true, activated_at: Time.zone.now)
    @email_address3 = @user.email_addresses.create(email: "howdie@world.org",  activated: false)
    @user.update_attribute(:primary_email_address_id, @email_address1.id)
    log_in @user
  end

  #
  # index tests
  #

  test "index when not logged in should redirect to root" do
    log_out
    get_index
    assert_redirected_with_flash [FlashMessages::NOT_LOGGED_IN], root_url
  end

  test "index should render index" do
    get_index
    assert_template :index
  end

  #
  # create tests
  #

  test "create with missing email should alert" do
    post_create nil
    assert_redirected_with_flash [UsersHelper::ValidationMessages::EMAIL_NOT_PRESENT], settings_email_identities_path

    post_create ""
    assert_redirected_with_flash [UsersHelper::ValidationMessages::EMAIL_NOT_PRESENT], settings_email_identities_path

    post_create "    "
    assert_redirected_with_flash [UsersHelper::ValidationMessages::EMAIL_NOT_PRESENT], settings_email_identities_path
  end

  test "create with too long email should alert" do
    e = "a" * (Lengths::EMAIL_ADDR_MAX + 1 - "@email.addr".length) + "@email.addr"
    post_create e
    assert_redirected_with_flash [UsersHelper::ValidationMessages::EMAIL_TOO_LONG], settings_email_identities_path

    e = "a" * (Lengths::EMAIL_ADDR_MAX - "@email.addr".length) + "@email.addr"
    post_create e
    assert_redirected_with_flash [FlashMessages::EMAIL_SENT], settings_email_identities_path
  end

  test "create with bad email format should alert" do
    post_create "bad@"
    assert_redirected_with_flash [UsersHelper::ValidationMessages::EMAIL_FORMATTING], settings_email_identities_path
  end

  test "create with taken email should alert" do
    post_create @email_address1.email
    assert_redirected_with_flash [UsersHelper::ValidationMessages::EMAIL_TAKEN], settings_email_identities_path
  end

  test "create when logged in should redirect to root" do
    log_out
    post_create "new@email.addr"
    assert_redirected_with_flash [FlashMessages::NOT_LOGGED_IN], root_url
  end

  test "create with valid params should send an email" do
    post_create"new@email.addr"
    # TODO: how to assert the email was sent
    assert_redirected_with_flash [FlashMessages::EMAIL_SENT], settings_email_identities_path
  end

  #
  # edit tests
  #

  test "edit for unknown id should alert" do
    get_edit 999999
    assert_redirected_with_flash [FlashMessages::EMAIL_UNKNOWN], settings_email_identities_path
  end
  
  test "edit for primary email should alert" do
    get_edit @email_address1.id
    assert_redirected_with_flash [FlashMessages::CANNOT_DO_TO_PRIMARY], settings_email_identities_path
  end

  test "edit for inactive email should alert" do
    get_edit @email_address3.id
    assert_redirected_with_flash [FlashMessages::EMAIL_NOT_ACTIVATED], settings_email_identities_path
  end

  test "edit when logged in should redirect to root" do
    log_out
    get_edit @email_address2.id
    assert_redirected_with_flash [FlashMessages::NOT_LOGGED_IN], root_url
  end

  test "edit with valid param should work" do
    get_edit @email_address2.id
    assert_redirected_with_flash [], settings_email_identities_path
    assert_equal @email_address2.id, @user.reload.primary_email_address_id
  end

  #
  # destroy tests
  #

  test "destroy for unknown id shoudl alert" do
    delete_destroy 999999
    assert_redirected_with_flash [FlashMessages::EMAIL_UNKNOWN], settings_email_identities_path
  end

  test "destroy for primary email should alert" do
    delete_destroy @email_address1.id
    assert_redirected_with_flash [FlashMessages::CANNOT_DO_TO_PRIMARY], settings_email_identities_path
  end

  test "delete for inactive email should not alert" do
    delete_destroy @email_address3.id
    assert_redirected_with_flash [], settings_email_identities_path
    assert_nil EmailAddress.find_by(id: @email_address3.id)
  end    

  test "destroy when logged out should redirect to root" do
    log_out
    delete_destroy @email_address2.id
    assert_redirected_with_flash [FlashMessages::NOT_LOGGED_IN], root_url
  end

  test "destroy with valid param should work" do
    delete_destroy @email_address2.id
    assert_redirected_with_flash [], settings_email_identities_path
    assert_nil EmailAddress.find_by(id: @email_address2.id)
  end
  
  private

  def get_index
    get :index
  end

  def post_create(email)
    post :create, new_identity: { email: email }
  end

  def get_edit(id)
    get :edit, id: id
  end

  def delete_destroy(id)
    delete :destroy, id: id
  end

end
