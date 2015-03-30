require 'test_helper'

class GroupEmailDomainChangeTest < ActiveSupport::TestCase

  test "missing statement_id shouldn't work" do
    assert_not GroupEmailDomainChange.new(domain: "addr.com", change_type: GroupEmailDomainChangeTypes[:add]).valid?
  end

    test "domain should be present" do
    assert_not GroupEmailDomainChange.new(statement_id: 1,                change_type: GroupEmailDomainChangeTypes[:add]).valid?
    assert_not GroupEmailDomainChange.new(statement_id: 1, domain: "",    change_type: GroupEmailDomainChangeTypes[:add]).valid?
    assert_not GroupEmailDomainChange.new(statement_id: 1, domain: "   ", change_type: GroupEmailDomainChangeTypes[:add]).valid?
  end

  test "too long domains should not be valid" do
    assert_not GroupEmailDomainChange.new(statement_id: 1,
                                          domain: "a" * (Lengths::EMAIL_DOMAIN_MAX + 1 - ".com".length) + ".com",
                                          change_type: GroupEmailDomainChangeTypes[:add]).valid?
    assert     GroupEmailDomainChange.new(statement_id: 1,
                                          domain: "a" * (Lengths::EMAIL_DOMAIN_MAX - ".com".length) + ".com",
                                          change_type: GroupEmailDomainChangeTypes[:add]).valid?
  end

  test "valid domains should be valid" do
    ["stanford.edu", "g.gmail.com", "ABC.o", "a-D123.net"].each do |valid_domain|
      assert GroupEmailDomainChange.new(statement_id: 1, domain: valid_domain, change_type: GroupEmailDomainChangeTypes[:add]).valid?
    end
  end

  test "invalid domains should not be valid" do
    ["stanford", "dot com", ".ABC.o", "a-D123."].each do |invalid_domain|
      assert_not GroupEmailDomainChange.new(statement_id: 1, domain: invalid_domain, change_type: GroupEmailDomainChangeTypes[:add]).valid?
    end
  end

  test "change types should work" do
    GroupEmailDomainChangeTypes.values.each do |change_type|
      assert GroupEmailDomainChange.new(statement_id: 1, domain: "addr.com", change_type: change_type).valid?, "problem with #{change_type}"
    end
    assert_not GroupEmailDomainChange.new(statement_id: 1, domain: "addr.com", change_type: 999999).valid?
  end
end
