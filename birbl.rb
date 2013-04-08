require 'birbl'
require 'yaml'

Birbl::Client.new('development')
Birbl::Client.instance.dev_url = 'http://localhost:8080'
Birbl::Client.instance.use_sandbox = true

a = Birbl::Activity.find(1)
puts a.t_and_c
a.t_and_c = 'these are the terms'
a.save
