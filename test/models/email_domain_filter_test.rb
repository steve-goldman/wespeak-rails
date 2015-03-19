require 'test_helper'

class EmailDomainFilterTest < ActiveSupport::TestCase

  include Constants

  test "domain should be present" do
    assert_not EmailDomainFilter.new.valid?
    assert_not EmailDomainFilter.new(domain: "").valid?
    assert_not EmailDomainFilter.new(domain: "   ").valid?
  end

  test "too long domains should not be valid" do
    assert_not EmailDomainFilter.new(domain: "a" * (Lengths::EMAIL_DOMAIN_MAX + 1 - ".com".length) + ".com").valid?
    assert     EmailDomainFilter.new(domain: "a" * (Lengths::EMAIL_DOMAIN_MAX - ".com".length) + ".com").valid?
  end

  test "valid domains should be valid" do
    ["stanford.edu", "g.gmail.com", "ABC.o", "a-D123.net"].each do |valid_domain|
      assert EmailDomainFilter.new(domain: valid_domain).valid?
    end
  end

  test "invalid domains should not be valid" do
    ["stanford", "dot com", ".ABC.o", "a-D123."].each do |invalid_domain|
      assert_not EmailDomainFilter.new(domain: invalid_domain).valid?
    end
  end

  test "duplicates should not be allowed" do
    EmailDomainFilter.create!(domain: "stanford.edu", active: false)
    assert_raises ActiveRecord::RecordNotUnique do
      EmailDomainFilter.create!(domain: "stanford.edu", active: false)
    end
  end
end
