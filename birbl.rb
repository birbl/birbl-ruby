require 'birbl'
require 'yaml'

action = Birbl::Action.new('development')
action.dev_url = 'http://localhost:8080'
action.use_sandbox = true

partner = {
  'description' => 'New partner description',
  'email'       => 'partner3@example.com',
  'name'        => 'Test partner from Ruby',
  'website'     => 'www.url.com'
}

puts action.get('partners').to_yaml
