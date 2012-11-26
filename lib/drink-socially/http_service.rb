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


      def make_request(args={}, connection_opts={})
        new(args,connection_opts).make_request
      end

    end

    self.faraday_middleware = self.default_middleware


    def initialize(args={}, connection_opts={})
      @connection_opts = connection_opts
      @response_class = args.delete(:response_class) || self.class.default_response_class
      @verb = args.delete(:verb)
      @url = args.delete(:url)
      @params = process_args(args)
      @args = args
    end


    def make_request
      connection = self.class.default_http_class.new @url, @connection_opts, &self.class.faraday_middleware
      response = connection.send @verb, @url, @params
      args = @args.merge( { body: response.body, headers: response.headers, status: response.status.to_i } )
      @response_class.new args
    rescue Faraday::Error::ParsingError => e
      self.class.default_response_class.new body: {error: e.message}, status: 500
    end

  private

    attr_reader :params, :verb, :url

    def process_args(args)
      return args unless @verb == :post
      args.inject("") { |str,pair| str += "#{pair.first}=#{pair.last}&" }.chop
    end

  end
end
