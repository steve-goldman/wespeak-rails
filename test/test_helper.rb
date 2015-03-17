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
    fclone = flash.clone
    flash_messages.each do |flash_message|
      assert !flash[flash_message.level].nil? && !(index = flash[flash_message.level].index(flash_message.message)).nil?,
             "[#{flash_message}] not found in flash"
      fclone[flash_message.level].delete_at(index)
      fclone.delete(flash_message.level) if flash[flash_message.level].empty?
    end

    unexpected_messages = []
    fclone.each { |message_type, message| unexpected_messages << FlashMessage.new(message_type, message).to_s }
    
    assert unexpected_messages.empty?, "Flash contains unexpected messages: " + unexpected_messages.join(",")
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
