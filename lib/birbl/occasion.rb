module Birbl
  class Occasion < Birbl::Resource

    def self.attribute_names
      super + [
        :activity_id,
        :begins,
        :ends,
        :available_from,
        :available_to
      ]
    end

    define_attributes

    validates_presence_of :begins
    validates_presence_of :ends

    def initialize(attributes = {}, activity = nil)
      @price_points  = []
      @current_price = nil
      @limits        = {:base_price => 0, :minimum_price => 0}
      @reservations  = []
      super attributes, activity
    end

    def activity=(activity)
      @activity = activity
    end

    def activity
      @activity
    end

    def price_points
      return @price_points unless @price_points.empty?

      data = Birbl::Client.instance.get("#{ path }/prices")

      @current_price = data[:current]
      @limits        = data[:limits]

      data[:price_points].each do |price|
        @price_points<< Birbl::PricePoint.new(price, self)
      end

      @price_points
    end

    def price_point(price)
      @price_points.each do |price_point|
        return price_point if price_point.price == price
      end

      nil
    end

    def begin_datetime
      DateTime.parse(begins)
    end

    def end_datetime
      DateTime.parse(ends)
    end

    def reserve(price, count, user_id = nil)
      # sanity check
      raise "#{ price } is not a valid price for this occasion." unless price_point(price)

      data = Birbl::Client.instance.post("#{ path }/reserve",
        :price_point => price,
        :count       => count,
        :user_id     => user_id
      )

      reservation = Birbl::Reservation.new(data[:reservation])
      data[:participations].each do |participation|
        reservation.add_participation(participation)
      end

      @reservations<< reservation

      reservation
    end

    def path
      "#{ post_path }/#{ id }"
    end

    def post_path
      "#{ activity.path }/occasions"
    end
  end
end
