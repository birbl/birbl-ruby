###
# The Activity resource
#

module Birbl
  class Activity < Birbl::Resource
    attr_reader :partner

    def initialize(partner, id = nil, data = {})
      @partner    = partner
      @occasions  = []

      super id, data
    end

    protected

    # Implements Birbl::Resource.fields
    def fields
      {
      'name'                  => {:writable => true, :not_null => true},
      'description'           => {:writable => true, :not_null => false},
      'base_price'            => {:writable => true, :not_null => true},
      'minimum_price'         => {:writable => true, :not_null => true},
      'maximum_capacity'      => {:writable => true, :not_null => true},
      'variation_limit'       => {:writable => true, :not_null => false},
      'discount_profile'      => {:writable => true, :not_null => false},
      'minimum_participants'  => {:writable => true, :not_null => false},
      'cost_per_participant'  => {:writable => true, :not_null => false},
      'fixed_costs'           => {:writable => true, :not_null => false}
      }
    end

    # Implements Birbl::Resource.url
    def url
      "partners/#{ @partner.id }/activities"
    end

  end
end
