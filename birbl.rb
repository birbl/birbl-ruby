require 'birbl'
require 'yaml'

Birbl::Client.new('development')
Birbl::Client.instance.dev_url = 'http://localhost:8080'
Birbl::Client.instance.use_sandbox = true

#p = Birbl::Partner.new(
#  :name         => 'test',
#  :description  => 'This & that',
#  :email        => 'foo@example.com'
#)
#p.save

p = Birbl::Partner.find(1)
puts p.to_yaml
p.save
