module Birbl
  class Reservation < Birbl::Resource
    def self.attribute_names
      super + [
        :occasion_id,
        :created_at,
        :options,
        :price_point,
        :updated_at,
        :user_id
      ]
    end

    define_attributes
  end
end
