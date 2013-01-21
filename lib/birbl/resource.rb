###
# Base class for a Birbl API resource.
#
module Birbl
  class Resource
    include ActiveModel::Validations
    include ActiveModel::Serialization

    attr_accessor :attributes

    def initialize(attributes = {})
      @attributes = attributes
    end

    def self.create(attributes)
      data = Birbl::Action.instance.post(self.base_url, self.post_data(attributes))

      new(data)
    end

    def update
      Birbl::Action.instance.put(url, self.class.post_data(@attributes))
    end

    def self.find(id)
      data = Birbl::Action.instance.get("#{ self.base_url }/#{ id }")
      new(data)
    end

    def self.delete(id)
      Birbl::Action.instance.delete("#{ self.base_url }/#{ id }")
    end

    def read_attribute_for_validation(key)
      @attributes[key]
    end

    def url
      "#{ self.class.base_url }/#{ @attributes['id'] }"
    end

    def self.base_url
      "resource"
    end

    def self.fields
      {
        'dummy' => {:writable => true, :not_null => false}
      }
    end

    # Return a hash of field data for fields specified by the API.  This removes any custom
    # properties that have been set before sending the data on.
    def self.post_data(attributes)
      data = {}
      self.fields.keys.each { |field|
        data[field] = attributes[field] if !attributes[field].nil? && self.fields[field][:writable]
      }

      return data
    end
  end
end
