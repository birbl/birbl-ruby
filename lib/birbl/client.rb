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
      begin
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
      rescue Exception => e
        # this is raised for any error coming from the server, including API errors, as the API
        # throws 500, 404, etc, which RestClient breaks on
        payload = e.respond_to?('http_body') ? JSON.parse(e.http_body) : {}
        raise build_error(e, uri, method, data, payload)
      end

      payload = JSON.parse(response.body)

      return HashWithIndifferentAccess.new(payload['data']) unless payload['data'].class == Array

      payload['data'].map { |item|
        item.select! { |k,v|
          puts "#{ k }: #{ v }"
          puts v.to_yaml
          v.class != Hash or !v.empty?
        }

        HashWithIndifferentAccess.new(item)
      }
    end

    private

    def build_error(error, uri, method, data, parsed)
      message = "RestClient did not get a good response from the server, responding with '#{ error.message }\n"
      message<< "The Birbl API server said: Error type #{parsed['error_type']} when making a #{ method.upcase } call to #{uri}.  " if parsed.has_key?('error_type')
      message<< "\nData in this call: #{ data.to_yaml }" unless data.empty?
      return message unless parsed.include?('errors')

      parsed['errors'].each_pair do |error, text|
        message += "#{error}: #{text}.  "
      end
      message
    end
  end
end
