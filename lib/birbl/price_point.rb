module Birbl
  class PricePoint < Birbl::Resource
    def self.attribute_names
      super + [
        :price,
        :necessary,
        :on,
        :participants,
        :paid,
        :states,
        :offset,
        :reached
      ]
    end

    define_attributes
  end
end
