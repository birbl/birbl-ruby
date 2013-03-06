require 'birbl'
require 'yaml'

Birbl::Client.new('development')
Birbl::Client.instance.dev_url = 'http://localhost:8080'
Birbl::Client.instance.use_sandbox = true

user = Birbl::User.find(1)
user.email = 'foo@example.com'
user.save

puts user.to_yaml
