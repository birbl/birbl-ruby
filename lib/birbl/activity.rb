###
# The Activity resource
#

module Birbl
  class Activity < Birbl::Resource
    def self.attribute_names
      super + [
        :partner_id,
        :name,
        :description,
        :base_price,
        :minimum_price,
        :maximum_capacity,
        :variation_limit,
        :discount_profile,
        :minimum_participants,
        :cost_per_participant,
        :fixed_costs,
        :options,
        :warnings,
        :active,
        :cancellation_policy,
        :t_and_c,
        :digital_asset_urls,
        :highlights,
        :what_you_get,
        :faq,
        :interest_list,
        :dates,
        :ical
      ]
    end

    define_attributes

    validates_presence_of :name
    validates_presence_of :base_price
    validates_presence_of :minimum_price
    validates_presence_of :maximum_capacity

    def initialize(attributes = {}, partner = nil)
      @occasions    = []
      @price_points = []
      @limits       = {}

      super attributes, partner

      if partner.nil? && !partner_id.nil?
        @partner = Birbl::Partner.find(partner_id)
      end
    end

    def partner=(partner)
      @partner = partner
    end

    def partner
      @partner
    end

    def occasion(id)
      child('occasion', id)
    end

    def occasions
      children('occasions')
    end

    def price_points
      if @price_points.empty?
        data = client.get "#{ path }/prices"

        @limits = data[:limits]

        data[:price_points].each do |price|
          @price_points<< Birbl::PricePoint.new(price, self)
        end
      end

      @price_points
    end

    def limits
      @limits
    end

    # Reserve an activity on the given date, at the given price point for the given amount
    # of people.  The reservation will be associated with the given user.  Price defaults
    # to the current going price
    def reserve(date, price = nil, count = 1, user_id = nil)
      data = client.post path + '/reserve',
        :datetime     => date,
        :price_point  => price,
        :quantity     => count,
        :user_id      => user_id


      reservation = Birbl::Reservation.new(data[:reservation])
      data[:participations].each do |participation|
        reservation.add_participation(participation)
      end

      reservation
    end

    def path
      "#{ post_path }/#{ id }"
    end

    def post_path
      "#{ partner.path }/activities"
    end

    def writable_attributes
      writable = {}
      attributes.keys.each do |key|
        next if [:partner_id, :warnings, :id].include?(key.to_sym)

        writable[key] = attributes[key]
      end

      writable
    end

    def occasion_by_date(date)
      date = DateTime.parse(date) unless date.class == DateTime or date.class == Time
      occasions.each do |occasion|
        return occasion if occasion.begin_datetime == date
      end

      nil
    end


    # Find active activities
    def self.active
      data = client.get('/activities/show_active')

      data.collect { |a_data| Birbl::Activity.new(a_data) }
    end

    # OBSOLETE???

    # Add one or more occasions, one for each date in the passed array.
    # Returns an array of new occasion objects
    #
    # Valid date strings are:
    #  * start / end:
    #     "20140101T153000Z/20140101T163000Z"
    #      This is equivalent to setting :begins and :ends in the data parameter
    #  * a comma delimited list:
    #     "20140101T153000ZP0Y0M0DT2H30M,20140104T153000ZP0Y0M0DT2H30M"
    #      Note the use of 'P' to indicate the period (or duration).
    #  * multiple dates as defined by an RRULE:
    #     "20140101T153000ZP0Y0M0DT2H30MRRULE:FREQ=WEEKLY;BYDAY=TU,TH;UNTIL=20140115T163000Z"
    def add_occasions(dates)
      occasions = []

      # hopefully the :dates parameter can eventually be moved to core.  For now it's handled here
      safe_dates = parse_dates(dates)

      # server may timeout if there is too much data here, so send 50 at time
      safe_dates.each_slice(50) do |date_chunk|
        data = client.post("#{ path }/occasions", date_chunk)
        data.each do |occasion_data|
          occasions<< add_child('occasion', occasion_data)
        end
      end

      occasions
    end

    def occasions_by_date(date, strict = false)
      d = DateTime.parse(date)

      matches = []
      occasions.each do |occasion|
        test1 = strict ? occasion.begin_datetime : occasion.begin_datetime.strftime('%Y%m%d')
        test2 = strict ? d : d.strftime('%Y%m%d')

        matches<< occasion if test1 == test2
      end

      matches
    end

    private

    def parse_dates(date_string)
      DateParser.new(date_string).dates
    end

    # END OBSOLETE
  end
end
