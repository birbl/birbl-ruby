module Birbl
  class User < Birbl::Resource

    def self.attribute_names
      super + [
        :username,
        :email,
        :active,
        :partner_id,
        :options,
        :reservations
        ]
    end

    define_attributes

    validates_presence_of :username
    validates_presence_of :email
    validates_presence_of :active

    def initialize(attributes = {}, parent = nil)
      @reservations = []
      super attributes, parent
    end

    def active?
       @active
    end

    def reservations
      return @reservations unless @reservations.empty?

      data = client.get("#{ path }/reservations")
      data.each do |item|
        @reservations<< Birbl::Reservation.find(item['id'])
      end

      @reservations
    end

    def self.find_by_email(email)
      attributes = client.get("users/show_by_email/#{ email.sub('.', '+') }")
      attributes.empty? ? nil : new(attributes)
    end

  end
end
