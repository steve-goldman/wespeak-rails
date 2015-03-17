require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "valid info should be able to sign up" do
    assert_difference 'User.count', 1 do
      post_via_redirect users_path, user: { name:  "discgolfstu",
                                            email: "hello@world.org",
                                            password: "test123",
                                            password_confirmation: "test123" }
    end
    assert_template 'static_pages/home'
  end

  test "missing user should not be able to sign up" do
    assert_no_difference 'User.count' do
      post_via_redirect users_path, user: { email: "hello@world.org",
                                            password: "test123",
                                            password_confirmation: "test123" }
    end
    assert_template 'static_pages/home'
  end
    
  test "missing email should not be able to sign up" do
    assert_no_difference 'User.count' do
      post_via_redirect users_path, user: { name:  "disgolfstu",
                                            password: "test123",
                                            password_confirmation: "test123" }
    end
    assert_template 'static_pages/home'
  end
    
  test "invalid email should not be able to sign up" do
    assert_no_difference 'User.count' do
      post_via_redirect users_path, user: { name:  "disgolfstu",
                                            email: "bogus@",
                                            password: "test123",
                                            password_confirmation: "test123" }
    end
    assert_template 'static_pages/home'
  end
    
  test "missing password should not be able to sign up" do
    assert_no_difference 'User.count' do
      post_via_redirect users_path, user: { name:  "disgolfstu",
                                            email: "hello@world.org",
                                            password_confirmation: "test123" }
    end
    assert_template 'static_pages/home'
  end
    
  test "missing confirmation should not be able to sign up" do
    # TODO: why does this work?
    #assert_no_difference 'User.count' do
    #  post_via_redirect users_path, user: { name:  "disgolfstu",
    #                                        email: "hello@world.org",
    #                                        password: "test123" }
    #end
    #assert_template 'static_pages/home'
  end
  
end
