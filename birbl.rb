require 'birbl'
require 'yaml'
require 'birbl/date_parser'

Birbl::Client.new('development')
Birbl::Client.instance.dev_url = 'http://localhost:8080'
Birbl::Client.instance.use_sandbox = true

  ical_string = <<-ICAL
DTSTART:20130314T201500Z
DTEND:20130314T201545Z
RRULE:FREQ=WEEKLY;BYDAY=TH;UNTIL=20130531T100000Z
ICAL

p = Birbl::Partner.find(1)

a = p.add_activity(
  :name                     => 'The new activity',
  :description              => 'The description',
  :base_price               => 100000,
  :minimum_price            => 50000,
  :maximum_capacity         => 100,
  :variation_limit          => 51,
  :discount_profile         => 'linear',
  :minimum_participants     => 50,
  :active                   => true,
  :cancellation_policy      => 'open',
  :t_and_c                  => "The ts and cs",
  :digital_asset_urls       => '',
  :highlights               => 'The highlights',
  :what_you_get             => 'What you get',
  :faq                      => 'FAQ',
  :dates                    => ical_string
)

puts a.to_yaml
