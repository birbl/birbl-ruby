###
# Handle interactions with the server.
#

require 'active_support/hash_with_indifferent_access'
require 'json'
require 'rest_client'

module Birbl
  class Client
    class << self
      @instance = nil

      def instance=(instance)
        @instance = instance
      end

      def instance
        raise 'No instance has been initialized' unless instance?
        @instance
      end

      def instance?
        not @instance.nil?
      end
    end

    attr_accessor :use_sandbox, :base_url, :dev_url, :timeout
    attr_reader   :api_key

    def initialize(api_key)
      self.class.instance = self unless self.class.instance?
      @api_key     = api_key
      @use_sandbox = false
      @base_url    = 'https://api.birbl.com'
      @dev_url     = 'https://dev-api.birbl.com'
      @timeout     = 10
    end

    def get(uri, data = [], pagination = nil)
      query_server(uri, data, 'get', pagination)
    end

    def post(uri, data = [], pagination = nil)
      query_server(uri, data, 'post', pagination)
    end

    def put(uri, data = [], pagination = nil)
      query_server(uri, data, 'put', pagination)
    end

    def delete(uri, data = [])
      query_server(uri, data, 'delete')
    end

    def url
      @use_sandbox ? @dev_url : @base_url
    end

    def json_data(data)
      "data=" + JSON.generate(data)
    end

    def query_server(uri, data = [], method = 'get', pagination = nil)
      # prefix a '/' if not present on the uri
      uri = '/' + uri if uri !~ /^\//

      response = nil
      case method
      when 'get'
        response = RestClient.get(url + uri, :BIRBL_KEY => @api_key)
      when 'post'
        response = RestClient.post(url + uri, json_data(data), :BIRBL_KEY => @api_key)
      when 'put'
        response = RestClient.put(url + uri, json_data(data), :BIRBL_KEY => @api_key)
      when 'delete'
        response = RestClient.delete(url + uri, :BIRBL_KEY => @api_key)
      end

      payload = JSON.parse(response.body)
      if payload.has_key?('error_type')
        raise build_error(uri, payload)
      end

      result = JSON.parse(payload['data'])
      HashWithIndifferentAccess.new(result)
    end

    private

    def build_error(uri, parsed)
      message = "Error type #{parsed['error_type']} returned from the server when calling #{uri}.  "
      return message unless parsed.include?('errors')

      parsed['errors'].each_pair do |error, text|
        message += "#{error}: #{text}.  "
      end
      message
    end
  end
end
