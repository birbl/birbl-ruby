###
# The Partner resource
#

module Birbl
  class Partner < Birbl::Resource

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
      activity = Birbl::Activity.find(id, self)
      @activities<< activity

      return activity
    end

    # Get an array of this partner's activities.
    #
    # They will be loaded from the API the first time they are requested
    def activities
      data = Birbl::Client.instance.get("#{ url }/activities")
      data.each { |item|
        add_activity(item)
      }
    end

    # Add an activity to this partner from the given data.
    #
    # If the activity does not already have an id, it will automatically be sent to the API
    # when this function is called
    def add_activity(data)
      activity = data['id'].nil? ? Birbl::Activity.create(data, self) : Birbl::Activity.new(data, self)
      @activities<< activity

      return activity
    end

    def self.base_url
      "partners"
    end

    def self.fields
      {
      'name'        => {:writable => true, :not_null => true},
      'description' => {:writable => true, :not_null => false},
      'email'       => {:writable => true, :not_null => true},
      'phone'       => {:writable => true, :not_null => false},
      'website'     => {:writable => true, :not_null => false}
      }
    end

  end
end
