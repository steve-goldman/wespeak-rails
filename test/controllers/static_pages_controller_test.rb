require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase
  def setup
    @user = User.new(name: "Stu", password: "test123", password_confirmation: "test123")
    @user.save!
  end

  test "home when logged out should get home" do
    get :home
    assert_response :success
    assert_template :home
  end

  test "home when logged in should get home" do
    log_in @user
    get :home
    assert_response :success
    assert_template :home
  end

end
