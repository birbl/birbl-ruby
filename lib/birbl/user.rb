require 'cgi'

module Birbl
  class User < Birbl::Resource

    def self.attribute_names
      super + [
        :username,
        :email,
        :active,
        :options,
        :reservations,
        :address
        ]
    end

    define_attributes

    validates_presence_of :username
    validates_presence_of :email
    validates_presence_of :active

    def initialize(attributes = {}, parent = nil)
      @reservations = []
      @partners     = []
      @address      = nil

      super attributes, parent
    end

    def active?
       @active
    end

    def reservations
      children('reservations')
    end

    def partners
      children('partners')
    end

    def writable_attributes
      attributes.select { |k,v| ['username', 'active', 'email', 'options', 'address'].include?(k.to_s) }
    end

    def self.find_by_email(email)
      attributes = client.get("users/show_by_email/#{ CGI.escape(email.sub('.', '+')) }")
      attributes.empty? ? nil : new(attributes)
    end

  end
end
