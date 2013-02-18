# Parse a string to generate an array of start/end date pairs
module Birbl
  require 'rrule'

  class DateParser

    def initialize(date_string)
      @dates = parse_dates(date_string)
    end

    def dates
      @dates
    end

    private

    def parse_dates(date_string)
      dates = []
      if date_string =~ /(.+?)RRULE:(.+)/
        dates += parse_rrule_item($1, $2)
      elsif date_string =~ /,/
        date_string.split(/\s*,\s*/).each { |date|
          dates<< parse_dates(date)
        }
      else
        dates<< parse_date_item(date_string)
      end

      dates
    end

    # Parse a single date string, which may indicate begin/end in one of two ways,
    # either START/END or STARTPERIOD.  The former is returned unchanged.  The latter
    # is transformed into the former.
    def parse_date_item(iso8601)
      return iso8601 unless iso8601 =~ /(.+?)P(.+)$/

      start  = DateTime.parse($1)
      period = $2
      period =~ /(\d+)Y(\d+)M(\d+)DT(\d+)H(\d+)M/

      years   = $1.to_i
      months  = $2.to_i
      days    = $3.to_i
      hours   = $4.to_i
      minutes = $5.to_i

      end_date = start.clone

      end_date >>= years * 12
      end_date >>= months
      end_date += days
      end_date += hours/24.0
      end_date += minutes/1440.0

      "#{ start.strftime(fmt) }/#{ end_date.strftime(fmt) }"
    end

    # Parse an RRULE to generate an array of start/end date pairs that
    # satisfy the rule.
    # It is likely that you want to pass the start date with a period indicator,
    # as opposed to an end date.
    def parse_rrule_item(start, rrule_string)
      parsed   = parse_date_item(start)
      duration = get_duration(parsed)
      rrule    = Rrule.new(rrule_string)
      current  = DateTime.parse(parsed)
      dates    = []

      rrule.dates(current).each do |date|
        end_date = date.to_time.to_i + duration
        dates<< "#{ date.strftime(fmt) }/#{ Time.at(end_date).to_datetime.strftime(fmt) }"
      end

      dates
    end

    # Get the distance between two dates indicated as START/END in seconds
    def get_duration(datestring)
      pair = datestring.split('/')

      DateTime.parse(pair[1]).to_time.to_i - DateTime.parse(pair[0]).to_time.to_i
    end

    def fmt
      '%Y%m%dT%H%M%SZ'
    end


  end
end
