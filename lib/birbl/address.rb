require 'cgi'

module Birbl
  class Address < Birbl::Resource

    def self.attribute_names
      super + [
          :street1,
          :street2,
          :city,
          :region,
          :country,
          :postal_code,
          :geo_ip_city_id,
          :geo_ip_country_id,
          :geo_ip_region_id,
          :lat,
          :lon,
          :index,
          :label
        ]
    end

    define_attributes

    def self.search_cities(term)
      client.get('/cities/search?term=' + CGI.escape(term))
    end

  end
end
