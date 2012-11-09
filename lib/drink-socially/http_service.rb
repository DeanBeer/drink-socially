require 'faraday'
require 'faraday_middleware/parse_oj'

module NRB
  module HTTPService

    autoload :Response, 'drink-socially/http_service/response'

    DEFAULT_MIDDLEWARE = Proc.new do |faraday| 
      faraday.adapter Faraday.default_adapter
      faraday.request  :url_encoded
      faraday.response :oj
    end

    class << self
      attr_accessor :faraday_middleware

      def default_middleware; DEFAULT_MIDDLEWARE; end

      def make_request(verb, path, args={})
        params = args.inject({}) do |hash,kv|
                                   hash[kv.first.to_s] = kv.last
                                   hash
                                 end
        request_options = { :params => (verb == :get ? params : {}) }
        connection = Faraday.new path, request_options, &faraday_middleware
        response = connection.send verb, path, (verb == :post ? params : {})
        Response.new response.status.to_i, response.body, response.headers
      rescue Faraday::Error::ParsingError => e
        Response.new 500, {'error' => e.message}, nil
      end

    end

    self.faraday_middleware = self.default_middleware

  end
end
