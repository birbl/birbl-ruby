require 'birbl'
require 'yaml'
require 'birbl/date_parser'

Birbl::Client.new('development')
Birbl::Client.instance.dev_url = 'http://localhost:8080'
Birbl::Client.instance.use_sandbox = true

dates = "20130416T140000ZP0Y0M0DT2H30MRRULE:FREQ=WEEKLY;BYDAY=MO,TH;UNTIL=20131031T163000Z"

dp = Birbl::DateParser.new(dates)

puts dp.dates
