###
# Handle interactions with the server.
#

module Birbl
  require 'json'

  class Action
    class << self
       # Set this to use a sandbox version of the API for testing
       # Default value is false
       attr_accessor :use_sandbox

       # Your API key, as provided by Birbl
       attr_accessor :api_key

       # The timeout value for calls to the server, you may want to increase this if you are getting
       # timeout errors.  Default value is 10
       attr_accessor :timeout

       # The live API URL, usually you can leave this blank
       attr_accessor :base_url

       # The sandbox API URL, usually you can leave this blank
       attr_accessor :dev_url
     end

    @use_sandbox  = false
    @api_key      = ''
    @base_url     = 'https://api.birbl.com'
    @dev_url      = 'https://dev-api.birbl.com'
    @timeout      = 10

    def Action.get(uri, data = [], pagination = nil)
      query_server(uri, data, 'get', pagination)
    end

    def Action.post(uri, data = [], pagination = nil)
      query_server(uri, data, 'post', pagination)
    end

    def Action.put(uri, data = [], pagination = nil)
      query_server(uri, data, 'put', pagination)
    end

    def Action.delete(uri, data = [])
      query_server(uri, data, 'delete')
    end

    def Action.url
      @use_sandbox ? @dev_url : @base_url
    end

    private

    def Action.query_server(uri, data = [], method = 'get', pagination = nil)
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
