require 'cgi'
require 'drink-socially/api/current_user'
require 'drink-socially/api/beer'
require 'drink-socially/api/user'

module NRB
  module Untappd
    class API

      class UnauthenticatedError < StandardError; end

      SERVER = 'api.untappd.com'
      API_VERSION = 'v4'

      autoload :Credentials, 'drink-socially/api/credentials'
      autoload :Pagination,  'drink-socially/api/pagination'
      autoload :RateLimit,   'drink-socially/api/rate_limit'
      autoload :Response,    'drink-socially/api/response'

      include CurrentUser
      include Beer
      include User

      attr_reader :credentials, :rate_limit, :response

      def self.api_version; API_VERSION; end
      def self.server; SERVER; end


      def api_call(verb, endpoint, args={})
        path = find_path_at(endpoint)
        args = @credentials.merge(args)

        response = NRB::Untappd.make_request(verb, path, args)
        @rate_limit = RateLimit.new(response.headers)
        @response = Response.new(response.status.to_i, response.body, response.headers)
      end


      def initialize(options={})
        @credentials = Credentials.new(options)
        @error = nil
      end

    private

      def find_path_at(endpoint)
        if @credentials.is_user?
          "http://#{API.server}/#{API.api_version}/#{endpoint}?access_token=#{@credentials.access_token}"
        else
          "http://#{API.server}/#{API.api_version}/#{endpoint}"
        end
      end

    end
  end
end
