###
# Base class for a Birbl API resource.
#

require 'active_support/hash_with_indifferent_access'

module Birbl
  class Resource
    include ActiveModel::Naming
    include ActiveModel::Serialization
    include ActiveModel::Validations

    attr_accessor :attributes

    def self.attribute_names
      [:id]
    end

    def self.define_attributes
      attribute_names.each do |attribute|
        define_method attribute do
          attributes[attribute]
        end

        define_method "#{attribute}=" do |value|
          attributes[attribute] = value
        end
      end
    end

    def self.collection_path
      collection = '' + self.model_name.collection
      collection.gsub!(%r(^birbl/), '')
      collection
    end

    def self.client
      Birbl::Client.instance
    end

    def self.create(attributes = {})
      resource = new(attributes)
      resource.save
      resource
    end

    def self.all
      results = client.get(collection_path)
      results.map { |attributes| new(attributes) }
    end

    def self.find(id, attributes = {})
      item = new(attributes.merge(:id => id))
      attributes = client.get(item.path)
      new(attributes)
    end

    def self.delete(id, attributes = {})
      item = new(attributes.merge(:id => id))
      client.delete(item.path)
    end

    def initialize(attributes = {})
      self.attributes = HashWithIndifferentAccess.new
      attributes.each do |name, value|
        send "#{name}=", value
      end
    end

    def path
      self.class.collection_path + "/#{id}"
    end

    def save
      was_new = new_record?
      result = was_new ? client.post(self.class.collection_path, as_json) : client.put(path, as_json)
      self.id = result['id'] if was_new
      true
    end

    def as_json
      attributes.symbolize_keys
    end

    def new_record?
      id.nil?
    end

    private

    def client
      self.class.client
    end
  end
end
