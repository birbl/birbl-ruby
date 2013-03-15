###
# The Partner resource
#

module Birbl
  class Partner < Birbl::Resource
    def self.attribute_names
      super + [
        :name,
        :description,
        :email,
        :telephone,
        :website,
        :options,
        :logo_url
      ]
    end

    define_attributes

    validates_presence_of :name
    validates_presence_of :email

    def initialize(attributes = {}, parent = nil)
      @activities = []
      @users      = []

      user_ids = attributes['users']
      attributes.delete('users')
      super attributes, parent

      unless user_ids.nil?
        user_ids.each do |user_data|
          @users<< Birbl::User.find(user_data['id'])
        end
      end
    end

    # Find a partner by it's email address
    def self.find_by_email(email)
      Birbl::Partner.all.each do |partner|
        return partner if partner.email == email
      end

      return nil
    end

    # Get an Activity from this partner by it's id.
    #
    # The Activity will be loaded from the API the first time it is requested
    def activity(id)
      child('activity', id)
    end

    # Get an array of this partner's activities.
    #
    # They will be loaded from the API the first time they are requested
    def activities
      return @activities unless @activities.empty?
      children('activities')
    end

    def users
      @users
    end

    # Add an activity to this partner from the given data.
    #
    # If the activity does not already have an id, it will automatically be sent to the API
    # when this function is called
    def add_activity(data)
      add_child('activity', data)
    end
  end
end
