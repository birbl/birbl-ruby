require 'spec_helper'

describe Birbl::Activity do
  let(:partner) { stub('Birbl::Partner') }
  let(:activity_attributes) do
    {
      'partner_id'            => 1,
      'id'                    => 10,
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
  end
end

