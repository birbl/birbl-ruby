require 'birbl'
require 'yaml'
require 'birbl/date_parser'

Birbl::Client.new('development')
Birbl::Client.instance.dev_url = 'http://localhost:8080'
Birbl::Client.instance.use_sandbox = true

a = Birbl::Activity.find(1)

a.addresses<< Birbl::Address.new({
  :street1  => '1234 Main St',
  :city     => 'Lake Forest',
  :region   => 'California',
  :country  => 'United States',
  :index    => a.addresses.count + 1
})

puts a.writable_attributes.to_yaml
#a.save

#a = Birbl::Activity.find(1)

#puts a.addresses.to_yaml
