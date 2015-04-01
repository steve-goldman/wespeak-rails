# no emails during seed
ActionMailer::Base.delivery_method = :test

#
# helper methods
#

def create_group(name, activate: true, domains: [], invitations: Invitations::NOT_REQUIRED, votespan_rule: 15.minutes.to_i)
  group = Group.create!(name: name, invitations: invitations, votespan_rule: votespan_rule)
  group.activate if activate
  domains.each { |domain| group.group_email_domains.create!(domain: domain) }
  group
end

def get_domain(email)
  email[(email.index("@") + 1)..-1]
end

def create_user(name, primary_email, password: "foobar", can_create_groups: false, primary_email_activated: true, other_emails: [])
  user = User.create!(name:                  name,
                      password:              password,
                      password_confirmation: password,
                      can_create_groups:     can_create_groups)
  primary_email_address = user.email_addresses.create!(email: primary_email, domain: get_domain(primary_email))
  primary_email_address.activate if primary_email_activated
  user.update_attributes(primary_email_address_id: primary_email_address.id)

  other_emails.each do |other_email|
    email_address = user.email_addresses.create!(email: other_email[:email], domain: get_domain(other_email[:email]))
    email_address.activate if other_email[:activated]
  end
end

#
# end helper methods
#


# make a group
test_group = create_group("test-group",
                          domains: ["gmail.com", "wespeakapp.com"],
                          invitations: 5)

test_group.send_invitation("steve@wespeakapp.com", false)

# make a user
steve_user = create_user("discgolfstu", "steve.goldman@gmail.com",
                         can_create_groups: true,
                         other_emails: [{ email: "steve@wespeakapp.com", activated: true  },
                                        { email: "stu@wespeakapp.com",   activated: false }])



#group2 = user.groups_i_created.create!(name: "another_group", invitations: 5)
#group2.group_email_domains.create!(domain: "criterion.com")
#group2.group_email_domains.create!(domain: "gmail.com")
#group2.activate
#group2.send_invitation("steve.goldman@gmail.com", false)
#
#GroupUserInfo.new(group.name, nil, user).make_member_active
#
## make a bunch of groups and make user active in them
#(1..30).each do |i|
#  new_group = user.groups_i_created.create!(name: "test-#{i}")
#  new_group.activate
#  GroupUserInfo.new(new_group.name, nil, user).make_member_active
#end
#
#include Constants
#
## make an alive statement
#alive_statement = group.create_statement(user, :tagline)
#Tagline.create(statement_id: alive_statement.id, tagline: "Two and two and two is six.")
#
## make a dead statement
#dead_statement = group.create_statement(user, :update)
#update = Update.create(statement_id: dead_statement.id, update_text: "The cheese stands alone.")
#dead_statement.update_attributes(created_at: Time.zone.now - group.lifespan_rule,
#                                 expires_at: Time.zone.now)
#StateMachine.alive_to_dead(Time.zone.now)
#
## make a voting statement
#voting_statement = group.create_statement(user, :tagline)
#tagline = Tagline.create(statement_id: voting_statement.id, tagline: "All of western thought is a series of footnotes to Plato.")
#voting_statement.add_support(user)
#StateMachine.alive_to_voting(Time.zone.now)
#
## make a rejected statement
#rejected_statement = group.create_statement(user, :update)
#update = Update.create(statement_id: rejected_statement.id, update_text: "Eureka, I have found it.")
#rejected_statement.add_support(user)
#StateMachine.alive_to_voting(Time.zone.now)
#rejected_statement.update_attributes(created_at:    Time.zone.now - group.votespan_rule - 1.hour,
#                                     updated_at:    Time.zone.now - group.votespan_rule,
#                                     vote_began_at: Time.zone.now - group.votespan_rule,
#                                     vote_ends_at:  Time.zone.now)
#rejected_statement.cast_vote(user, Votes::NO)
#StateMachine.end_votes(Time.zone.now)
#
## make a accepted statement
#accepted_statement = group.create_statement(user, :tagline)
#tagline = Tagline.create(statement_id: accepted_statement.id, tagline: "There is no spoon.")
#accepted_statement.add_support(user)
#StateMachine.alive_to_voting(Time.zone.now)
#accepted_statement.update_attributes(created_at:    Time.zone.now - group.votespan_rule - 1.hour,
#                                     updated_at:    Time.zone.now - group.votespan_rule,
#                                     vote_began_at: Time.zone.now - group.votespan_rule,
#                                     vote_ends_at:  Time.zone.now)
#accepted_statement.cast_vote(user, Votes::YES)
#StateMachine.end_votes(Time.zone.now)
#
## make an accepted support needed change
#support_statement = group.create_statement(user, :rule)
#rule = Rule.create(statement_id: support_statement.id, rule_type: RuleTypes[:support_needed], rule_value: 1)
#support_statement.add_support(user)
#StateMachine.alive_to_voting(Time.zone.now)
#support_statement.update_attributes(created_at:    Time.zone.now - group.votespan_rule - 1.hour,
#                                    updated_at:    Time.zone.now - group.votespan_rule,
#                                    vote_began_at: Time.zone.now - group.votespan_rule,
#                                    vote_ends_at:  Time.zone.now)
#support_statement.cast_vote(user, Votes::YES)
#StateMachine.end_votes(Time.zone.now)
#
## accept a new email domain
#add_domain_statement = group.create_statement(user, :group_email_domain_change)
#add_domain_change = GroupEmailDomainChange.create(statement_id: add_domain_statement.id, change_type: GroupEmailDomainChangeTypes[:add], domain: "haha.com")
#add_domain_statement.add_support(user)
#StateMachine.alive_to_voting(Time.zone.now)
#add_domain_statement.update_attributes(created_at:    Time.zone.now - group.votespan_rule - 1.hour,
#                                       updated_at:    Time.zone.now - group.votespan_rule,
#                                       vote_began_at: Time.zone.now - group.votespan_rule,
#                                       vote_ends_at:  Time.zone.now)
#add_domain_statement.cast_vote(user, Votes::YES)
#StateMachine.end_votes(Time.zone.now)
#
## accept removing an email domain
#rem_domain_statement = group.create_statement(user, :group_email_domain_change)
#rem_domain_change = GroupEmailDomainChange.create(statement_id: rem_domain_statement.id, change_type: GroupEmailDomainChangeTypes[:remove], domain: "wespeakapp.com")
#rem_domain_statement.add_support(user)
#StateMachine.alive_to_voting(Time.zone.now)
#rem_domain_statement.update_attributes(created_at:    Time.zone.now - group.votespan_rule - 1.hour,
#                                       updated_at:    Time.zone.now - group.votespan_rule,
#                                       vote_began_at: Time.zone.now - group.votespan_rule,
#                                       vote_ends_at:  Time.zone.now)
#rem_domain_statement.cast_vote(user, Votes::YES)
#StateMachine.end_votes(Time.zone.now)
#
