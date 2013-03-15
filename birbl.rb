require 'birbl'
require 'yaml'

Birbl::Client.new('development')
Birbl::Client.instance.dev_url = 'http://localhost:8080'
Birbl::Client.instance.use_sandbox = true

s = "2001tommaso+t@pestalozzi.wickischool.it"

puts Birbl::User.find_by_email(s).to_yaml
