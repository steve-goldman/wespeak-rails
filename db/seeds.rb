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
group.activate

group2 = user.groups_i_created.create!(name: "another_group")
group2.group_email_domains.create!(domain: "criterion.com")
group2.activate
