require 'birbl'
require 'yaml'
require 'birbl/date_parser'

Birbl::Client.new('development')
Birbl::Client.instance.dev_url = 'http://localhost:8080'
Birbl::Client.instance.use_sandbox = true

p = Birbl::Partner.find(1)

puts "count: #{ p.partner_awards.count }"
p.partner_awards.last.delete

p = Birbl::Partner.find(1)
puts "count: #{ p.partner_awards.count }"
