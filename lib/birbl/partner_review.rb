module Birbl
  class PartnerReview < Birbl::Resource

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
  end
end
