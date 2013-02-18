module Birbl
  class PricePoint < Birbl::Resource
    def self.attribute_names
      super + [
        :price,
        :necessary,
        :on,
        :opt_ins,
        :cancelled,
        :participants,
        :offset,
        :reached
      ]
    end

    define_attributes
  end
end
