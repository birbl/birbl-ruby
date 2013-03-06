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

    def self.create(attributes = {}, parent = nil)
      resource = new(attributes, parent)
      resource.save
      resource
    end

    def self.all
      results = client.get(collection_path)
      results.map { |attributes| new(attributes) }
    end

    def self.find(id, attributes = {}, parent = nil)
      item = new(attributes.merge(:id => id), parent)
      attributes = client.get("#{ self.resource_name.pluralize }/#{ id }")
      new(attributes, parent)
    end

    def self.delete(id, attributes = {})
      item = new(attributes.merge(:id => id))
      client.delete(item.path)
    end

    def self.resource_name
      self.model_name.to_s.downcase.sub('birbl::', '')
    end

    def initialize(attributes = {}, parent = nil)
      self.attributes = HashWithIndifferentAccess.new
      attributes.each do |name, value|
        send "#{name}=", value
      end

      unless parent.nil?
        instance_variable_set("@#{ parent.class.resource_name }", parent)
      end
    end

    def path
      self.class.collection_path + "/#{id}"
    end

    def post_path
      self.class.collection_path
    end

    def save
      was_new = new_record?
      result = was_new ? client.post(post_path, as_json) : client.put(path, as_json)
      self.id = result['id'] if was_new
      true
    end

    def as_json
      puts writable_attributes.to_yaml
      writable_attributes.symbolize_keys
    end

    def writable_attributes
      attributes
    end

    def new_record?
      id.nil?
    end

    # Get an array of this resource's child resources.
    #
    # They will be loaded from the API the first time they are requested
    def children(resource)
      data = Birbl::Client.instance.get("#{ path }/#{ resource }")
      data.each do |item|
        add_child(resource.singularize, item)
      end
      instance_variable_get("@#{ resource }")
    end

    # Add an activity to this partner from the given data.
    #
    # If the activity does not already have an id, it will automatically be sent to the API
    # when this function is called
    def add_child(resource, data)
      resource_model = "Birbl::#{ resource.camelize}".constantize
      parent_name = self.class.resource_name

      object =
        if data['id'].nil?
          resource_model.create(data, self)
        else
          resource_model.new(data, self)
        end

      add_to_children(resource, object)

      object
    end

    # Get an child from this resource by it's id.
    #
    # The child resource will be loaded from the API the first time it is requested
    def child(resource, id)
      resource_model = "Birbl::#{ resource.camelize}".constantize

      object = resource_model.find(id, {}, self)
      add_to_children(resource, object)

      object
    end

    private

    def add_to_children(resource, child)
      children = instance_variable_get("@#{ resource.pluralize }")
      children << child
      instance_variable_set("@#{ resource.pluralize }", children)
    end

    def client
      self.class.client
    end
  end
end
