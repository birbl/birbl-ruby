###
# The Activity resource
#

module Birbl
  class Activity < Birbl::Resource
    def self.attribute_names
      super + [
        :partner_id,
        :name,
        :description,
        :base_price,
        :minimum_price,
        :maximum_capacity,
        :variation_limit,
        :discount_profile,
        :minimum_participants,
        :cost_per_participant,
        :fixed_costs
      ]
    end

    define_attributes

    validates_presence_of :name
    validates_presence_of :base_price
    validates_presence_of :minimum_price
    validates_presence_of :maximum_capacity

    def partner=(partner)
      @partner = partner
      self.partner_id = partner.id
    end

    def partner
      return @partner if @partner
      @partner = Partner.find(partner_id)
    end

    def path
      "partners/#{partner_id}/" + self.class.collection_path + "/#{id}"
    end
  end
end

