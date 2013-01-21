require 'birbl'
require 'yaml'

Birbl::Action.new('development')
Birbl::Action.instance.dev_url = 'http://localhost:8080'
Birbl::Action.instance.use_sandbox = true

#partner = {
#  'description' => 'New partner description',
#  'email'       => 'partner3@example.com',
#  'name'        => 'Test partner from Ruby',
#  'website'     => 'www.url.com'
#}

#puts Birbl::Action.instance.post('partners', partner).to_yaml

partner = Birbl::Partner.new()
partner.property('name', '')
puts "valid? #{ partner.has_valid_data? }"
