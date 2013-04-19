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
        :faq
      ]
    end

    define_attributes

    validates_presence_of :name
    validates_presence_of :base_price
    validates_presence_of :minimum_price
    validates_presence_of :maximum_capacity

    def initialize(attributes = {}, partner = nil)
      @occasions = []
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

    def occasion_by_date(date)
      d = DateTime.parse(date)
      occasions.each do |occasion|
        return occasion if occasion.begin_datetime == d
      end

      nil
    end

    def occasions
      children('occasions')
    end

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

    # Find active activities
    def self.active
      data = client.get('/activities/show_active')

      data.collect { |a_data| Birbl::Activity.new(a_data) }
    end

    # Reserve an activity on the given date, at the given price point for the given amount
    # of people.  The reservation will be associated with the given user.  Price defaults
    # to the current going price
    def reserve(date, price = nil, count = 1, user_id = nil)
      occasion = occasion_by_date(date)
      raise "No occasion found for #{ date }" if occasion.nil?

      occasion.reserve(price, count, user_id)
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
        next if [:partner_id, :warnings].include?(key.to_sym)

        writable[key] = attributes[key]
      end

      writable
    end

    private

    def parse_dates(date_string)
      DateParser.new(date_string).dates
    end
  end
end
