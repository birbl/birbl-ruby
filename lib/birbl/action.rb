###
# Handle interactions with the server.
#

module Birbl
  require 'json'

  class Action
    class << self
      attr_accessor :instance

      @instance = nil
    end

    attr_accessor :use_sandbox, :base_url, :dev_url, :timeout
    attr_reader   :api_key

    def initialize(api_key)
      self.class.instance = self if self.class.instance.nil?
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

    def query_server(uri, data = [], method = 'get', pagination = nil)
      # prefix a '/' if not present on the uri
      uri = '/' + uri if uri !~ /^\//

      sess = Patron::Session.new
      sess.timeout = @timeout
      sess.headers['User-Agent'] = 'birbl-ruby/1.0'
      sess.headers['BIRBL_KEY'] = @api_key
      sess.base_url = Action.url

      response = nil
      if method == 'get'
        response = sess.get(uri)
      end

      raise SecurityError, "The server says 'Unauthorized'.  Did you set your API key?" if response.status == 401
      raise "#{ uri } doesn't go anywhere." if response.status == 404

      payload = JSON.parse(response.body)

      if payload.has_key?('error_type')
        message = "Error type #{ payload['error_type'] } returned from the server when calling #{ uri }."
        payload['errors'].keys.each { |error|
          message += "#{ error }: #{ payload['errors'][error] }.  "
        }

        raise message
      end

      return payload['data']
    end
  end
end
