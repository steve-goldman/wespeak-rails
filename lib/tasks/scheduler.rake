task :state_transitions => :environment do
  now = Time.zone.now
  puts "#{now}: alive => dead..."
  count = StateMachine.alive_to_dead(now)
  puts "        #{count} to dead"
  now = Time.zone.now
  puts "#{now}: alive => voting..."
  count = StateMachine.alive_to_voting(now)
  puts "        #{count} to voting"
  now = Time.zone.now
  puts "#{now}: end votes..."
  count = StateMachine.end_votes(now)
  puts "        #{count} ended"
  now = Time.zone.now
  puts "#{now}: expired memberships..."
  count = StateMachine.expired_memberships(now)
  puts "        #{count} expired"
  now = Time.zone.now
  puts "#{now}: membership warnings..."
  count = StateMachine.membership_warnings(now)
  puts "        #{count} warnings"
  now = Time.zone.now
  puts "#{now}: done"
end