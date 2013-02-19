module Birbl
  class Participation < Birbl::Resource
    def self.attribute_names
      super + [
        :occasion_id,
        :reservation_id,
        :price_point,
        :state,
        :lock_timeout,
        :token,
        :options
      ]
    end

    define_attributes
  end
end
