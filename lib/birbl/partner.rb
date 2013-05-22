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
        :logo_url,
        :users,
        :qualifications,
        :partner_reviews,
        :partner_awards,
        :partner_presses,
        :social_links
      ]
    end

    define_attributes

    validates_presence_of :name
    validates_presence_of :email

    def initialize(attributes = {}, parent = nil)
      @activities       = []
      @partner_reviews  = []
      @partner_presses  = []
      @partner_awards   = []

      super attributes, parent
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
      children('activities')
    end

    def partner_review(id)
      child('partner_review', id)
    end

    def partner_reviews
      children('partner_reviews')
    end

    def partner_award(id)
      child('partner_award', id)
    end

    def partner_awards
      children('partner_awards')
    end

    def partner_press(id)
      child('partner_press', id)
    end

    def partner_presses
      children('partner_presses')
    end

    # Add a partner review to this partner from the given data.
    def add_partner_review(data)
      add_child('partner_review', data)
    end

    # Add a partner press item to this partner from the given data.
    def add_partner_press(data)
      add_child('partner_press', data)
    end

    # Add a partner review to this partner from the given data.
    def add_partner_award(data)
      add_child('partner_award', data)
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
