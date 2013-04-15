require 'birbl'
require 'yaml'
require 'birbl/date_parser'

Birbl::Client.new('development')
Birbl::Client.instance.dev_url = 'http://localhost:8080'
Birbl::Client.instance.use_sandbox = true

cities = Birbl::Address.search_cities('New Y')
puts cities.to_yaml

exit
user_data = {
  :active    => true,
  :email     => 'info3@example.com',
  :username  => 'test',
  :options   => {},
  :address => {
    :street1      => '129 Baggot St Lower',
    :street2      => 'c/o Birbl',
    :city         => 'Dublin',
    :region       => 'Dublin Co.',
    :country      => 'Ireland',
    :postal_code  => 'Dublin 2',

    :geo_ip_city_id     => nil,
    :geo_ip_country_id  => nil,
    :geo_ip_region_id   => nil,

    :lat    => nil,
    :lon    => nil
  }
}

u = Birbl::User.new(user_data)
u.save
