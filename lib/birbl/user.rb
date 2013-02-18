module Birbl
  class User < Birbl::Resource
    def self.attribute_names
      super + [
        :username,
        :email,
        :partner_id,
        :active
      ]
    end

    define_attributes
  end
end
