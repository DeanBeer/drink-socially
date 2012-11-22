require 'faraday'
require 'faraday_middleware/parse_oj'

module NRB
  class HTTPService

    autoload :Response, 'drink-socially/http_service/response'

    DEFAULT_MIDDLEWARE = Proc.new do |faraday| 
      faraday.adapter Faraday.default_adapter
      faraday.request  :url_encoded
      faraday.response :oj
    end

    class << self
      attr_accessor :faraday_middleware

      def default_middleware; DEFAULT_MIDDLEWARE; end
      def default_http_class; Faraday; end
      def default_response_class; Response; end


      def make_request(verb, url, args={}, connection_opts={})
        new(verb,url,args,connection_opts).make_request
      end

    end

    self.faraday_middleware = self.default_middleware


    def initialize(verb, url, args={}, connection_opts={})
      @connection_opts = connection_opts
      @url = url
      @verb = verb
      @args = process_args(args)
    end


    def make_request

      connection = self.class.default_http_class.new @url, @connection_opts, &self.class.faraday_middleware

      response = connection.send @verb, @url, @args

      self.class.default_response_class.new response.status.to_i, response.body, response.headers

    rescue Faraday::Error::ParsingError => e
      self.class.default_response_class.new 500, {error: e.message}, nil
    end

  private

    def process_args(args)
      return args unless @verb == :post
      args.inject("") { |str,pair| str += "#{pair.first}=#{pair.last}&" }.chop
    end

  end
end
