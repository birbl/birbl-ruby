###
# Handle interactions with the server.
#

module Birbl
  class Action
    class << self
       attr_accessor :use_sandbox, :key, :base_url, :dev_url
     end

    @use_sandbox = false
    @key = ''
    @base_url = 'https://api.birbl.com'
    @dev_url = 'https://dev-api.birbl.com'

    def Action.get(uri, data = [])
      query_server(uri, data, 'get')
    end

    def Action.post(uri, data = [])
      query_server(uri, data, 'post')
    end

    def Action.put(uri, data = [])
      query_server(uri, data, 'put')
    end

    def Action.delete(uri, data = [])
      query_server(uri, data, 'delete')
    end

    def Action.url
      @use_sandbox ? @dev_url : @base_url
    end

    private

    def Action.query_server(uri, data = [], method = 'get')
      [{}]
    end
  end
end
