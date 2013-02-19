module Birbl
  class User < Birbl::Resource

    def self.attribute_names
      super + [
        :username,
        :email,
        :active,
        :partner_id,
        :options
        ]
    end

    define_attributes

    validates_presence_of :username
    validates_presence_of :email
    validates_presence_of :active


    def active?
       @active
    end

    def self.find_by_email(email)
      attributes = client.get("users/show_by_email/#{ email.sub('.', '+') }")
      attributes.empty? ? nil : new(attributes)
    end

  end
end
