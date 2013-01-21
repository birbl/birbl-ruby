###
# The Partner resource
#

module Birbl
  class Partner < Birbl::Resource

    def initialize(id = nil, data = {})
      @activities = []

      super id, data
    end

    # Get an Activity from this partner by it's id.
    #
    # The Activity will be loaded from the API the first time it is requested
    def activity(id)
      activity = Birbl::Activity.new(self, id)
      @activities<< activity

      return activity
    end

    # Get an array of this partner's activities.
    #
    # They will be loaded from the API the first time they are requested
    def activities
      data = Birbl::Action.instance.get("#{ url }/#{ @id }/activities")
      data.each { |item|
        add_activity(item)
      }
    end

    # Add an activity to this partner from the given data.
    #
    # If the activity does not already have an id, it will automatically be sent to the API
    # when this function is called
    def add_activity(data)
      activity = Birbl::Activity.new(self, nil, data)
      @activities<< activity

      return activity
    end

    protected

    # Implements Birbl::Resource.fields
    def fields
      {
      'name'        => {:writable => true, :not_null => true},
      'description' => {:writable => true, :not_null => false},
      'email'       => {:writable => true, :not_null => true},
      'phone'       => {:writable => true, :not_null => false},
      'website'     => {:writable => true, :not_null => false}
      }
    end

    # Implements Birbl::Resource.url
    def url
      'partners'
    end

  end
end
