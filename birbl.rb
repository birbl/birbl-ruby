require 'birbl'
require 'yaml'

Birbl::Client.new('development')
Birbl::Client.instance.dev_url = 'http://localhost:8080'
Birbl::Client.instance.use_sandbox = true

activity = Birbl::Activity.find(5)
puts activity.occasions.length

occasion = activity.occasion(33)
puts activity.occasions.length
