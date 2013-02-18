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
        :cancellation_policy
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
    end

    def partner=(partner)
      @partner = partner
      self.partner_id = partner.id
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

      data = client.post("#{ path }/occasions", safe_dates)
      data.each do |occasion_data|
        occasions<< add_child('occasion', occasion_data)
      end

      occasions
    end

    def path
      "#{ post_path }/#{ id }"
    end

    def post_path
      "#{ partner.path }/activities"
    end

    private

    def parse_dates(date_string)
      DateParser.new(date_string).dates
    end
  end
end
