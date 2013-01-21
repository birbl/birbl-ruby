###
# Base class for a Birbl API resource.
#
module Birbl
  class Resource

    def initialize(id = nil, data = {})
      @data = {}
      @id   = id.nil? ? (data.has_key?('id') ? data['id'] : nil) : id

      if !@id.nil?
        load(@id)
      end

      if !data.empty?
        data.keys.each { |field|
          property(field, data[field])
        }
      end
    end

    # Load this instance from the API
    def load(id)
      @id = id

      data = Birbl::Action.instance.get(url + '/' + id.to_s)
      data.keys.each { |field|
        property(field, data[field])
      }
    end

    # Create this instance on the API
    def create
      raise "Cannot create a resource without a valid id" if @id.nil?
      raise "Cannot create a resource with invalid data" if !has_valid_data?

      Birbl::Action.instance.post(url + '/' + @id.to_s, post_data)
    end

    # Update this instance to the API
    def update
      raise "Cannot update a resource without a valid id" if @id.nil?
      raise "Cannot update a resource with invalid data" if !has_valid_data?

      Birbl::Action.instance.put(url + '/' + @id.to_s, post_data)
    end

    # Update this instance from the API
    def delete(id = nil)
      delete_id = id.nil? ? @id : id
      raise "Cannot update a resource without a valid id" if delete_id.nil?

      Birbl::Action.instance.delete(url + '/' + delete_id.to_s)
    end

    # Get or set the value for a given field
    #
    # name: the name of the field
    # value: If anything other than nil, the value to set for this field
    #
    # Returns the current value of the field
    def property(name, value = nil)
      raise "Setting a value on read-only field #{ name } is not allowed" if !value.nil? && !field_is_writable?(name)
      raise "Setting an invalid value on field #{ name }" if !value.nil? && !is_valid_field_data?(name, value)

      @data[name] = value if !value.nil?

      return @data[name]
    end

    def field_exists?(name)
      fields.has_key?(name)
    end

    def field_is_writable?(name)
      return true if !field_exists?(name)

      fields[name][:writable]
    end

    # Validate all field values
    def has_valid_data?
      fields.keys.each { |field|
        val = property(field)

        return false if fields[field][:not_null] && (val.nil? || val.empty?)
        return false if !is_valid_field_data?(field, val)
      }

      return true
    end


    protected

    ###########
    # Specific sub classes MUST implement
    #

    # Returns a data structure defining the fields for this entity
    # The function must be implemented by any derived class and must be a hash containing the names
    # of the fields.  The value of each entry must be a hash containing the following:
    #   - writable: true or false
    #   - not null: true or false
    def fields
      {'placeholder' => {:writable => true, :not_null => false}}
    end

    # The base URL for this resource
    def url
      'resource'
    end

    ###########
    # Specific sub classes MAY implement
    #

    # Validate a field value
    #
    # name: the name of the field
    # value: If anything other than nil, the value to set for this field
    #
    # Returns true if the value is valid for this field.  Note that your implementation does not
    # have to check if a :not_null field has a value here, as that is checked in has_valid_data?
    # before any data is sent to the server.  This function only needs to check that IF data is
    # present, it is valid.
    def is_valid_field_data?(name, value)
      true
    end

    # Return a hash of field data for fields specified by the API.  This removes any custom
    # properties that have been set before sending the data on.
    def post_data
      data = {}
      fields.keys.each { |field|
        data[field] = @data[field]
      }

      return data
    end
  end
end
