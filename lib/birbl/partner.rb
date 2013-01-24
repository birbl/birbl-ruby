###
# The Partner resource
#

module Birbl
  class Partner < Birbl::Resource
    def self.attribute_names
      super + [:name, :description, :email, :phone, :website]
    end

    define_attributes

    validates_presence_of :name
    validates_presence_of :email

    def initialize(attributes = {})
      @activities = []
      super attributes
    end

    # Get an Activity from this partner by it's id.
    #
    # The Activity will be loaded from the API the first time it is requested
    def activity(id)
      activity = Birbl::Activity.find(id, :partner => self)
      @activities << activity

      activity
    end

    # Get an array of this partner's activities.
    #
    # They will be loaded from the API the first time they are requested
    def activities
      data = Birbl::Client.instance.get("#{path}/activities")
      data.each do |item|
        add_activity(item)
      end
      @activities
    end

    # Add an activity to this partner from the given data.
    #
    # If the activity does not already have an id, it will automatically be sent to the API
    # when this function is called
    def add_activity(data)
      activity = 
        if data['id'].nil?
          Birbl::Activity.create(data.merge(:partner_id => self))
        else
          Birbl::Activity.new(data)
        end
      @activities << activity

      activity
    end
  end
end

