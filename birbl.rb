require 'birbl'
require 'yaml'
require 'birbl/date_parser'

Birbl::Client.new('development')
Birbl::Client.instance.dev_url = 'http://localhost:8080'
Birbl::Client.instance.use_sandbox = true

u = Birbl::User.find(1)
puts u.to_yaml

#u.address.country = 'Ireland'
#u.save
