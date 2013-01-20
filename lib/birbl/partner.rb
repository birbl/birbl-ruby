require 'active_model'
require 'birbl/action'

module Birbl
  class Partner
    include ActiveModel::Validations
    include ActiveModel::Serialization

    validates_presence_of :name

    attr_accessor :attributes

    def self.create(attributes)
      data = Birbl::Action.instance.post('/partners', attributes)
      new(data)
    end

    def self.find(id)
      data = Birbl::Action.instance.get('/partners/%u' % id)
      new(data)
    end

    def initialize(attributes = {})
      @attributes = attributes
    end

    def read_attribute_for_validation(key)
      @attributes[key]
    end
  end
end


