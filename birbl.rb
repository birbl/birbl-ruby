require 'birbl'
require 'yaml'

Birbl::Client.new('development')
Birbl::Client.instance.dev_url = 'http://localhost:8080'
Birbl::Client.instance.use_sandbox = true

partner_data = {
  'id'      => 1,
  'name'    => 'Dummy partner',
  'email'   => 'partner@example.com',
  'website' => 'www.example.com'
}

partner = Birbl::Partner.find(456)

activity_data = {
  'name'                  => 'Dummy activity',
  'description'           => 'Activity desription',
  'base_price'            => 1000,
  'minimum_price'         => 100,
  'maximum_capacity'      => 10,
  'minimum_participants'  => 1,

  # optional
  'variation_limit'       => 4,
  'cost_per_participant'  => 100,
  'fixed_costs'           => 300
}

activity = partner.activity(1225)
Birbl::Activity.delete(1225, partner)
