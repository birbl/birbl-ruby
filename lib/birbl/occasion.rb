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
      @price_points = []
      super attributes, activity
    end

    def activity=(activity)
      @activity = activity
      self.activity_id = activity.id
    end

    def activity
      @activity
    end

    def path
      "#{ post_path }/#{ id }"
    end

    def post_path
      "#{ activity.path }/occasions"
    end
  end
end
