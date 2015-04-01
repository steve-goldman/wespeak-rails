# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# steve always has an account
user = User.create!(name:                  "discgolfstu",
                    password:              "foobar",
                    password_confirmation: "foobar",
                    can_create_groups:     true)

primary_email_address = user.email_addresses.create!(email: "steve.goldman@gmail.com", domain: "gmail.com", activated: true, activated_at: Time.zone.now)
user.email_addresses.create!(email: "steve@wespeakapp.com", domain: "wespeakapp.com", activated: true, activated_at: Time.zone.now)
user.email_addresses.create!(email: "stu@wespeakapp.com",   domain: "wespeakapp.com", activated: false)

user.update_attribute(:primary_email_address_id, primary_email_address.id)

group = user.groups_i_created.create!(name: "test_group")
group.group_email_domains.create!(domain: "wespeakapp.com")
group.group_email_domains.create!(domain: "gmail.com")
group.activate

user.received_invitations.create!(group_id: group.id)

group2 = user.groups_i_created.create!(name: "another_group", invitations: 5)
group2.group_email_domains.create!(domain: "criterion.com")
group2.group_email_domains.create!(domain: "gmail.com")
group2.activate

user.received_invitations.create!(group_id: group2.id)

GroupUserInfo.new(group.name, nil, user).make_member_active

# make a bunch of groups and make user active in them
(1..30).each do |i|
  new_group = user.groups_i_created.create!(name: "test-#{i}")
  new_group.activate
  GroupUserInfo.new(new_group.name, nil, user).make_member_active
end

include Constants

# make an alive statement
alive_statement = group.create_statement(user, :tagline)
Tagline.create(statement_id: alive_statement.id, tagline: "Two and two and two is six.")

# make a dead statement
dead_statement = group.create_statement(user, :update)
update = Update.create(statement_id: dead_statement.id, update_text: "The cheese stands alone.")
dead_statement.update_attributes(created_at: Time.zone.now - group.lifespan_rule,
                                 expires_at: Time.zone.now)
StateMachine.alive_to_dead(Time.zone.now)

# make a voting statement
voting_statement = group.create_statement(user, :tagline)
tagline = Tagline.create(statement_id: voting_statement.id, tagline: "All of western thought is a series of footnotes to Plato.")
voting_statement.add_support(user)
StateMachine.alive_to_voting(Time.zone.now)

# make a rejected statement
rejected_statement = group.create_statement(user, :update)
update = Update.create(statement_id: rejected_statement.id, update_text: "Eureka, I have found it.")
rejected_statement.add_support(user)
StateMachine.alive_to_voting(Time.zone.now)
rejected_statement.update_attributes(created_at:    Time.zone.now - group.votespan_rule - 1.hour,
                                     updated_at:    Time.zone.now - group.votespan_rule,
                                     vote_began_at: Time.zone.now - group.votespan_rule,
                                     vote_ends_at:  Time.zone.now)
rejected_statement.cast_vote(user, Votes::NO)
StateMachine.end_votes(Time.zone.now)

# make a accepted statement
accepted_statement = group.create_statement(user, :tagline)
tagline = Tagline.create(statement_id: accepted_statement.id, tagline: "There is no spoon.")
accepted_statement.add_support(user)
StateMachine.alive_to_voting(Time.zone.now)
accepted_statement.update_attributes(created_at:    Time.zone.now - group.votespan_rule - 1.hour,
                                     updated_at:    Time.zone.now - group.votespan_rule,
                                     vote_began_at: Time.zone.now - group.votespan_rule,
                                     vote_ends_at:  Time.zone.now)
accepted_statement.cast_vote(user, Votes::YES)
StateMachine.end_votes(Time.zone.now)

# make an accepted support needed change
support_statement = group.create_statement(user, :rule)
rule = Rule.create(statement_id: support_statement.id, rule_type: RuleTypes[:support_needed], rule_value: 1)
support_statement.add_support(user)
StateMachine.alive_to_voting(Time.zone.now)
support_statement.update_attributes(created_at:    Time.zone.now - group.votespan_rule - 1.hour,
                                    updated_at:    Time.zone.now - group.votespan_rule,
                                    vote_began_at: Time.zone.now - group.votespan_rule,
                                    vote_ends_at:  Time.zone.now)
support_statement.cast_vote(user, Votes::YES)
StateMachine.end_votes(Time.zone.now)

# accept a new email domain
add_domain_statement = group.create_statement(user, :group_email_domain_change)
add_domain_change = GroupEmailDomainChange.create(statement_id: add_domain_statement.id, change_type: GroupEmailDomainChangeTypes[:add], domain: "haha.com")
add_domain_statement.add_support(user)
StateMachine.alive_to_voting(Time.zone.now)
add_domain_statement.update_attributes(created_at:    Time.zone.now - group.votespan_rule - 1.hour,
                                       updated_at:    Time.zone.now - group.votespan_rule,
                                       vote_began_at: Time.zone.now - group.votespan_rule,
                                       vote_ends_at:  Time.zone.now)
add_domain_statement.cast_vote(user, Votes::YES)
StateMachine.end_votes(Time.zone.now)

# accept removing an email domain
rem_domain_statement = group.create_statement(user, :group_email_domain_change)
rem_domain_change = GroupEmailDomainChange.create(statement_id: rem_domain_statement.id, change_type: GroupEmailDomainChangeTypes[:remove], domain: "wespeakapp.com")
rem_domain_statement.add_support(user)
StateMachine.alive_to_voting(Time.zone.now)
rem_domain_statement.update_attributes(created_at:    Time.zone.now - group.votespan_rule - 1.hour,
                                       updated_at:    Time.zone.now - group.votespan_rule,
                                       vote_began_at: Time.zone.now - group.votespan_rule,
                                       vote_ends_at:  Time.zone.now)
rem_domain_statement.cast_vote(user, Votes::YES)
StateMachine.end_votes(Time.zone.now)
