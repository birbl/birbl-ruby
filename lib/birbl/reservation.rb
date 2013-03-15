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
        :state,
        :paid,
        :payment_data
      ]
    end

    define_attributes

    def initialize(attributes = {}, parent = nil)
      @participations  = []
      @user = nil

      # if called from Birbl::Resource.find, attributes has data from the server
      if attributes.has_key?(:reservation)
        super attributes[:reservation], parent

        attributes[:participations].each do |p_data|
          add_participation(p_data)
        end
      else
        super attributes, parent
      end

      if occasion.nil? && !occasion_id.nil?
        @occasion = Birbl::Occasion.find(occasion_id)
      end

      if user_id
        @user = Birbl::User.find(user_id)
      end
    end

    def occasion=(occasion)
      @occasion = occasion
    end

    def occasion
      @occasion
    end

    def user
      @user
    end

    def participations
      @participations
    end

    def add_participation(data)
      add_child('participation', data)
    end

    def pay(payment_data)
      client.post("#{ path }/pay", payment_data)
    end

    def cancel(participation_ids = [])
      if participation_ids.empty?
          participation_ids = participations.collect { |p| p.id }
      end

      client.put(path, {:cancel => participation_ids})
    end

    def self.payment_due
      data = Birbl::Client.instance.get("reservations/payments/due")
      data.collect { |r_data| Birbl::Reservation.new(r_data) }
    end
  end
end
