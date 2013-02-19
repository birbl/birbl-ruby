module Birbl
  class Reservation < Birbl::Resource
    def self.attribute_names
      super + [
        :occasion_id,
        :created_at,
        :options,
        :price_point,
        :updated_at,
        :user_id,
        :state
      ]
    end

    define_attributes

    def initialize(attributes = {}, parent = nil)
      @participations  = []

      # if called from Birbl::Resource.find, attributes has data from the server
      if attributes.has_key?(:reservation)
        super attributes[:reservation], parent

        attributes[:participations].each do |p_data|
          add_participation(p_data)
        end
      else
        super attributes, parent
      end
    end

    def participations
      children('participations')
    end

    def add_participation(data)
      add_child('participation', data)
    end
  end
end
