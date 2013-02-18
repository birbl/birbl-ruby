class Rrule

  def initialize(rrule)
    @rrule_parts = {}
    @rrule = rrule
    @rrule.split(';').each do |rule|
      key, value = rule.split('=')
      send "#{ key.downcase }=", value
    end
  end

  def method_missing(meth, *args, &block)
    if known_methods.include?(meth.to_s)
      run_rule_accessor(meth.to_s.sub('=', ''), *args, &block)
    else
      super
    end
  end

  def run_rule_accessor(rule, *args, &block)
    @rrule_parts[rule] = args[0] if args.length == 1
    @rrule_parts[rule]
  end

  def respond_to?(meth)
    known_methods.include?(meth)
  end

  # Get the end date of this RRULE as a DateTime object
  # If none can be found, returns the default given
  def end_date(default = nil)
    return DateTime.parse(self.until) if self.until

    return default
    #@todo handle the rest
  end

  # Get an array of dates that this rrule implies, starting from the given start date
  def dates(start = DateTime.now)
    included_dates = []
    current = start.clone

    while current < end_date
      included_dates<< current if included_date?(current)

      current = next_date(current)
    end

    included_dates
  end

  # Determine if this date is included by the RRULE
  # We only handle WEEKLY frequencies at the moment
  def included_date?(datetime)
    case freq
    when 'WEEKLY'
      days = byday.split(',')
      days.each do |day|
        return true if datetime.strftime('%a')[0,2].upcase == day
      end
    end

    false
  end

  # Get the next date from this datetime, according to the INTERVAL rule
  # Currently, only returns the next day
  def next_date(datetime)
    datetime + 1
  end

  def known_rules
    %w(freq until byday)
  end

  def known_methods
    methods = known_rules.clone
    known_rules.each { |m| methods<< "#{ m }="}

    methods
  end

end
