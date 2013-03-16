require 'birbl'
require 'yaml'

Birbl::Client.new('development')
Birbl::Client.instance.dev_url = 'http://localhost:8080'
Birbl::Client.instance.use_sandbox = true

puts Birbl::Occasion.find(1).reservations[0].participations.to_yaml
