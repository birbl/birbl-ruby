###
# The Activity resource
#

module Birbl
  class Activity < Birbl::Resource
    attr_reader :partner

    def initialize(attributes = {}, partner)
      @partner    = partner
      @occasions  = []

      super attributes
    end

    def self.create(attributes, partner)
      data = Birbl::Client.instance.post("#{ self.base_url(partner.attributes['id']) }", self.post_data(attributes))

      new(data, partner)
    end

    def self.find(id, partner)
      data = Birbl::Client.instance.get("#{ self.base_url(partner.attributes['id']) }/#{ id }")

      new(data, partner)
    end

    def self.delete(id, partner)
      Birbl::Client.instance.delete("#{ self.base_url(partner.attributes['id']) }/#{ id }")
    end

    def url
      "#{ self.class.base_url(@partner.attributes['id']) }/#{ @attributes['id'] }"
    end

    def self.base_url(partner_id)
      "partners/#{ partner_id }/activities"
    end

    def self.fields
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
  end
end
