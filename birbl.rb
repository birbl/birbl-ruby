require 'birbl'
require 'yaml'
require 'birbl/date_parser'

Birbl::Client.new('development')
Birbl::Client.instance.dev_url = 'http://localhost:8080'
Birbl::Client.instance.use_sandbox = true


r = Birbl::Reservation.find(1)
puts "due: #{ r.amount_due }"
puts "cost: #{ r.occasion.current_price }"
r.save
