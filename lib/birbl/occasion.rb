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
      @reservations  = []
      @current_price = nil
      @limits        = {:base_price => 0, :minimum_price => 0}
      @reservations  = []
      super attributes, activity

      if activity.nil? && !activity_id.nil?
        @activity = Birbl::Activity.find(activity_id)
      end
    end

    def activity=(activity)
      @activity = activity
    end

    def activity
      @activity
    end

    def reservations
      if @reservations.empty?
        data = Birbl::Client.instance.get("#{ path }/reservations")
        data.each do |reservation_data|
          @reservations<< Birbl::Reservation(new(reservation_data))
        end
      end

      @reservations
    end

    def price_points
      if @price_points.empty?
        data = Birbl::Client.instance.get("#{ path }/prices")

        @current_price = data[:current]
        @limits        = data[:limits]

        data[:price_points].each do |price|
          @price_points<< Birbl::PricePoint.new(price, self)
        end
      end

      @price_points
    end

    # Get a price point from a price amount.  Pass nil to get back the current going price.
    def price_point(price = nil)
      price_points.each do |price_point|
        return price_point if (price.nil? && is_current_price?(price_point)) or (!price.nil? && price_point.price == price)
      end

      nil
    end

    def is_current_price?(price_point)
      price_point.price == @current_price[:price]
    end

    # Returns the current price for this occasion in euro cents
    def current_price
      # make sure prices are loaded
      price_points if @current_price.nil?

      @current_price
    end

    def begin_datetime
      DateTime.parse(begins)
    end

    def end_datetime
      DateTime.parse(ends)
    end

    # Return the date this occasion becomes active.  Either the available_from or begins field
    def active_on
      available_from || begins
    end

    # Reserve this occasion.  Price defaults to the current going price.
    def reserve(price = nil, count = 1, user_id = nil)
      # sanity check
      point = price_point(price)
      raise "#{ price } is not a valid price for this occasion." if point.nil?

      data = Birbl::Client.instance.post("#{ path }/reserve",
        :price_point => point.price,
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
