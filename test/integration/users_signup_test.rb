require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "valid info should be able to sign up" do
    assert_difference 'User.count', 1 do
      post_via_redirect create_user_path, user: { name:  "discgolfstu",
                                                  password: "test123" }
    end
    assert_template 'static_pages/home'
  end

  test "missing user should not be able to sign up" do
    assert_no_difference 'User.count' do
      post_via_redirect create_user_path, user: { password: "test123" }
    end
    assert_template 'static_pages/home'
  end
    
  test "missing password should not be able to sign up" do
    assert_no_difference 'User.count' do
      post_via_redirect create_user_path, user: { name:  "disgolfstu" }
    end
    assert_template 'static_pages/home'
  end
    
end
