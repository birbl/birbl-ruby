require 'birbl'
require 'yaml'
require 'birbl/date_parser'

Birbl::Client.new('development')
Birbl::Client.instance.dev_url = 'http://localhost:8080'
Birbl::Client.instance.use_sandbox = true


a = Birbl::Activity.find(12)
a.reserve("2013-05-30 20:15:00 UTC", 1000, 2)
