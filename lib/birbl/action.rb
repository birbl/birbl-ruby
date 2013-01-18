###
# Handle interactions with the server.
#

module Birbl
  class Action
    class << self
      attr_accessor :instance

      @instance = nil
    end

    attr_accessor :use_sandbox, :base_url, :dev_url
    attr_reader   :key

    def initialize(key)
      self.class.instance = self if self.class.instance.nil?
      @key = key
      @use_sandbox = false
      @base_url = 'https://api.birbl.com'
      @dev_url = 'https://dev-api.birbl.com'
    end

    def get(uri, data = [])
      query_server(uri, data, 'get')
    end

    def post(uri, data = [])
      query_server(uri, data, 'post')
    end

    def put(uri, data = [])
      query_server(uri, data, 'put')
    end

    def delete(uri, data = [])
      query_server(uri, data, 'delete')
    end

    def url
      @use_sandbox ? @dev_url : @base_url
    end

    private

    def query_server(uri, data = [], method = 'get')
      [{}]
    end
  end
end

