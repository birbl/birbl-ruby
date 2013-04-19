require 'birbl'
require 'yaml'
require 'birbl/date_parser'

Birbl::Client.new('development')
Birbl::Client.instance.dev_url = 'http://localhost:8080'
Birbl::Client.instance.use_sandbox = true



a = Birbl::Activity.find(1)
puts a.address.to_yaml
