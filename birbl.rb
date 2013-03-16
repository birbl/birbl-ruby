require 'birbl'
require 'yaml'

Birbl::Client.new('development')
Birbl::Client.instance.dev_url = 'http://localhost:8080'
Birbl::Client.instance.use_sandbox = true

p = Birbl::Partner.find(1)
p.users<< Birbl::User.find(2)
p.save
puts p.users.to_yaml
