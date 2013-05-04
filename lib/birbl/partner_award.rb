module Birbl
  class PartnerAward < Birbl::Resource

    def self.attribute_names
      super + [
          :partner_id,
          :source,
          :source_url,
          :image_url,
          :description
        ]
    end

    define_attributes

    def initialize(attributes = {}, partner = nil)
      super attributes, partner

      if partner.nil? && !partner_id.nil?
        @partner = Birbl::Partner.find(partner_id)
      end
    end

    def partner=(partner)
      @partner = partner
    end

    def partner
      @partner
    end

    def path
      "#{ post_path }/#{ id }"
    end

    def post_path
      "#{ partner.path }/partner_awards"
    end

  end
end
