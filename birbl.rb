require 'birbl'


Birbl::Action.dev_url = 'http://localhost:8080'
Birbl::Action.use_sandbox = true

puts Birbl::Action.url
