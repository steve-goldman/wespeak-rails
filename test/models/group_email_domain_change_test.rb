require 'test_helper'

class GroupEmailDomainChangeTest < ActiveSupport::TestCase

  test "missing statement_id shouldn't work" do
    assert_not GroupEmailDomainChange.new(domain: "email@addr.com").valid?
  end

    test "domain should be present" do
    assert_not GroupEmailDomainChange.new(statement_id: 1).valid?
    assert_not GroupEmailDomainChange.new(statement_id: 1, domain: "").valid?
    assert_not GroupEmailDomainChange.new(statement_id: 1, domain: "   ").valid?
  end

  test "too long domains should not be valid" do
    assert_not GroupEmailDomainChange.new(statement_id: 1, domain: "a" * (Lengths::EMAIL_DOMAIN_MAX + 1 - ".com".length) + ".com").valid?
    assert     GroupEmailDomainChange.new(statement_id: 1, domain: "a" * (Lengths::EMAIL_DOMAIN_MAX - ".com".length) + ".com").valid?
  end

  test "valid domains should be valid" do
    ["stanford.edu", "g.gmail.com", "ABC.o", "a-D123.net"].each do |valid_domain|
      assert GroupEmailDomainChange.new(statement_id: 1, domain: valid_domain).valid?
    end
  end

  test "invalid domains should not be valid" do
    ["stanford", "dot com", ".ABC.o", "a-D123."].each do |invalid_domain|
      assert_not GroupEmailDomainChange.new(statement_id: 1, domain: invalid_domain).valid?
    end
  end

end
