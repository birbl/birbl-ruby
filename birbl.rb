require 'birbl'
require 'yaml'

Birbl::Action.api_key = 'development'
Birbl::Action.dev_url = 'http://localhost:8080'
Birbl::Action.use_sandbox = true

puts Birbl::Action.get('partners/450/activities/1220').to_yaml
