module NRB
  module Untappd
    class API

      API_VERSION = :v4           # Use NRB::Untappd::API.api_version instead
      SERVER = 'api.untappd.com'  # Use NRB::Untappd::API.server instead

      autoload :Credential,      'drink-socially/api/credential'
      autoload :Pagination,      'drink-socially/api/pagination'
      autoload :RateLimit,       'drink-socially/api/rate_limit'
      autoload :Object,          'drink-socially/api/object'
      autoload :URLTokenizer, 'drink-socially/api/url_tokenizer'

      attr_reader :credential, :endpoints, :rate_limit

      def self.api_version; API_VERSION; end
      def self.default_rate_limit_class; RateLimit; end
      def self.default_response_class; Object; end
      def self.requestor; NRB::Untappd; end
      def self.server; SERVER; end


      # http://untappd.com/api/docs/v4#checkin
      # Required args: bid
      def add_checkin(args)
        validate_api_args args, :bid
        t = Time.now
        args[:endpoint] = 'checkin/add'
        args[:gmt_offset] ||= t.gmt_offset / 3600
        args[:timezone] ||= t.zone
        args[:verb] = :post
        api_call args
      end


      def api_call(args)
        endpoint = args.delete(:endpoint)
        config = get_config endpoint
        return unless config

        validate_api_args args, *config[:required_args]

        args.merge!(config)

        args[:response_class] ||= self.class.default_response_class

        tokenizer = URLTokenizer.new map: args, string: args.delete(:endpoint)
        args[:url] = find_path_at tokenizer.tr

        response = self.class.requestor.make_request(args)
        @rate_limit = self.class.default_rate_limit_class.new(response.headers)
        response
      end


      def initialize(args={})
        @api_version = args[:api_version] || self.class.api_version
        @credential = args[:credential] || Credential.new(args.dup)
        @server = args[:server] || self.class.server
        define_endpoints_from(args)
      end

    private

      def api_call_lambda(args)
        lambda { |opts={}| api_call opts.merge({endpoint: args[:endpoint]}) }
      end

      def credential_string_for_url
        @credential.is_user? ? "?access_token=#{@credential.access_token}" : ""
      end


      def define_endpoint_aliases(args)
        return unless args[:orig]
        args[:aliases].each do |name|
          define_singleton_method name, api_call_lambda(endpoint: name)
        end
      end


      def define_endpoints_from(args)
        @endpoints = args[:endpoints] || NRB::Untappd.load_config(filekey: (args[:config_file] || 'endpoints.yml'))
        @endpoints.each do |endpoint,endpoint_config|
          define_singleton_method endpoint, api_call_lambda(endpoint: endpoint)
          endpoint_config[:method_aliases] && define_endpoint_aliases(orig: endpoint, aliases: endpoint_config[:method_aliases])
        end
      end


      def endpoint_base
        "http://#{@server}/#{@api_version}/"
      end


      def extract_info_from(response, *keys)
        return unless response.success?
        keys.inject(response.body) { |hash, key| hash[key] }
      end


      def find_path_at(endpoint)
        endpoint_base + endpoint.to_s + credential_string_for_url
      end


      def get_config(endpoint)
        config = @credential.merge(@endpoints[endpoint])
        return unless config
        config[:verb] ||= :get
        config
      end


      def validate_api_args(args, *required_args)
        raise ArgumentError.new("Please supply a hash") unless args.is_a?(Hash)
        required_args.each do |arg|
          raise ArgumentError.new("Missing required #{arg} parameter") unless !! args[arg]
        end
      end

    end
  end
end
