ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "minitest/reporters"
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  include ApplicationHelper

  include SessionsHelper

  def assert_flash(flash_messages)
    flash_messages.each do |flash_message|
      assert !flash[flash_message.level].nil? && flash[flash_message.level].include?(flash_message.message),
             "[#{flash_message.level}: '#{flash_message.message}'] not found in flash"
    end
  end
  
  def assert_redirected_with_flash(flash_messages, link)
    assert_flash(flash_messages)
    assert_redirected_to link
  end

  def assert_rendered_with_flash(flash_messages, template)
    assert_flash(flash_messages)
    assert_template template
  end

  def assert_logged_in_as(user)
    assert current_user == user
  end
end
