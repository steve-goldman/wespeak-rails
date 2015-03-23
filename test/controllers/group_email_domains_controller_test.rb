require 'test_helper'

class GroupEmailDomainsControllerTest < ActionController::TestCase

  include GroupsHelper

  def setup
    @user = User.create!(name:                  "Stu",
                         password:              "test123",
                         password_confirmation: "test123",
                         can_create_groups:     true)
    log_in @user
    @group = @user.groups_i_created.create!(name: "added_group")
    @domain = @group.group_email_domains.create!(domain: "stanford.edu")
  end

  #
  # create tests
  #

  test "create when not logged in should redirect" do
    log_out
    post_create @group.id, "stanford.edu"
    assert_redirected_with_flash [FlashMessages::NOT_LOGGED_IN], root_url
  end

  test "create when cannot create groups should redirect" do
    @user.update_attribute(:can_create_groups, false)
    post_create @group.id, "stanford.edu"
    assert_redirected_with_flash [FlashMessages::CANNOT_CREATE_GROUPS], root_url
  end

  test "create for unknown group should redirect" do
    post_create 999999, "stanford.edu"
    assert_redirected_with_flash [FlashMessages::GROUP_UNKNOWN], groups_path
  end

  test "create with missing domain should redirect" do
    [nil, "", "   "].each do |missing_domain|
      post_create @group.id, missing_domain
      assert_rendered_with_flash [ValidationMessages::DOMAIN_NOT_PRESENT], 'groups/edit'
    end
  end

  test "create with taken domain should redirect" do
    new_domain = "wespeakapp.com"
    post_create @group.id, new_domain
    assert_not_nil GroupEmailDomain.find_by(group_id: @group.id, domain: new_domain)
    assert_redirected_with_flash [], edit_group_path(@group.id)
    post_create @group.id, new_domain
    assert_rendered_with_flash [ValidationMessages::DOMAIN_TAKEN], 'groups/edit'
    post_create @group.id, new_domain.upcase
    assert_rendered_with_flash [ValidationMessages::DOMAIN_TAKEN], 'groups/edit'
  end

  test "create with too long domain should redirect" do
    domain = "a" * (Lengths::EMAIL_DOMAIN_MAX - ".com".length + 1) + ".com"
    post_create @group.id, domain
    assert_rendered_with_flash [ValidationMessages::DOMAIN_TOO_LONG], 'groups/edit'

    domain = "a" * (Lengths::EMAIL_DOMAIN_MAX - ".com".length) + ".com"
    post_create @group.id, domain
    assert_not_nil GroupEmailDomain.find_by(group_id: @group.id, domain: domain)
    assert_redirected_with_flash [], edit_group_path(@group.id)
  end

  test "create with bad domain format should redirect" do
    ["stanford", "dot com", ".ABC.o", "a-D123."].each do |invalid_domain|
      post_create @group.id, invalid_domain
      assert_rendered_with_flash [ValidationMessages::DOMAIN_FORMATTING], 'groups/edit'
    end
  end

  test "create with valid domain format should redirect" do
    ["wespeakapp.edu", "g.gmail.com", "ABC.com", "a-D123.net"].each do |valid_domain|
      post_create @group.id, valid_domain
      assert_redirected_with_flash [], edit_group_path(@group.id)
      assert_not_nil GroupEmailDomain.find_by(group_id: @group.id, domain: valid_domain.downcase)
    end
  end


  #
  # destroy tests
  #

  test "destroy when not logged in should redirect" do
    log_out
    delete_destroy @group.id, @domain.id
    assert_redirected_with_flash [FlashMessages::NOT_LOGGED_IN], root_url
  end

  test "destroy when cannot create groups should redirect" do
    @user.update_attribute(:can_create_groups, false)
    delete_destroy @group.id, @domain.id
    assert_redirected_with_flash [FlashMessages::CANNOT_CREATE_GROUPS], root_url
  end

  test "destroy for unknown group should redirect" do
    post_create 999999, @domain.id
    assert_redirected_with_flash [FlashMessages::GROUP_UNKNOWN], groups_path
  end

  test "destroy for unknown domain should redirect" do
    delete_destroy @group.id, 999999
    assert_redirected_with_flash [FlashMessages::DOMAIN_UNKNOWN], groups_path
  end

  test "destroy for active group should redirect" do
    @group.update_attribute(:active, true)
    delete_destroy @group.id, @domain.id
    assert_redirected_with_flash [FlashMessages::GROUP_ACTIVE], groups_path
  end
  
  test "destroy for another user's group should redirect" do
    other_user = User.create!(name:                  "Mike",
                              password:              "test123",
                              password_confirmation: "test123",
                              can_create_groups:     true)
    other_group = other_user.groups_i_created.create!(name: "other_group")
    other_domain = other_group.group_email_domains.create!(domain: "uiuc.edu")
    delete_destroy other_group.id, other_domain.id
    assert_redirected_with_flash [FlashMessages::USER_MISMATCH], groups_path
  end

  test "destroy with valid params should work" do
    delete_destroy @group.id, @domain.id
    assert_redirected_with_flash [], edit_group_path(@group.id)
    assert_nil GroupEmailDomain.find_by(id: @domain.id)
  end

  
  private

  def post_create(group_id, domain)
    post :create, group_id: group_id, group_email_domain: { domain: domain }
  end

  def delete_destroy(group_id, domain_id)
    post :destroy, group_id: group_id, id: domain_id
  end

end
