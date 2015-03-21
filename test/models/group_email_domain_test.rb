require 'test_helper'

class GroupEmailDomainTest < ActiveSupport::TestCase

  include Constants

  def setup
    @group = Group.create!(name: "group_name")
  end

  test "domain should be present" do
    assert_not @group.group_email_domains.build.valid?
    assert_not @group.group_email_domains.build(domain: "").valid?
    assert_not @group.group_email_domains.build(domain: "   ").valid?
  end

  test "too long domains should not be valid" do
    assert_not @group.group_email_domains.build(domain: "a" * (Lengths::EMAIL_DOMAIN_MAX + 1 - ".com".length) + ".com").valid?
    assert     @group.group_email_domains.build(domain: "a" * (Lengths::EMAIL_DOMAIN_MAX - ".com".length) + ".com").valid?
  end

  test "valid domains should be valid" do
    ["stanford.edu", "g.gmail.com", "ABC.o", "a-D123.net"].each do |valid_domain|
      assert @group.group_email_domains.build(domain: valid_domain).valid?
    end
  end

  test "invalid domains should not be valid" do
    ["stanford", "dot com", ".ABC.o", "a-D123."].each do |invalid_domain|
      assert_not @group.group_email_domains.build(domain: invalid_domain).valid?
    end
  end

  test "duplicates should not be allowed" do
    @group.group_email_domains.create!(domain: "stanford.edu")
    assert_raises ActiveRecord::RecordNotUnique do
      @group.group_email_domains.create!(domain: "stanford.edu")
    end
  end
end
