module NRB
  module Untappd
    class API

      API_VERSION = :v4           # Use NRB::Untappd::API.api_version instead
      SERVER = 'api.untappd.com'  # Use NRB::Untappd::API.server instead

      autoload :Credential, 'drink-socially/api/credential'
      autoload :Pagination,  'drink-socially/api/pagination'
      autoload :RateLimit,   'drink-socially/api/rate_limit'
      autoload :Object,    'drink-socially/api/object'

      attr_reader :credential, :rate_limit

      def self.api_version; API_VERSION; end
      def self.default_credential_class; Credential; end
      def self.default_rate_limit_class; RateLimit; end
      def self.default_response_class; Object; end
      def self.requestor; NRB::Untappd; end
      def self.server; SERVER; end


      # http://untappd.com/api/docs/v4#friend_accept
      # Required args: user_id
      def accept_friend(args)
        validate_api_args args, :user_id
        args[:endpoint] = "friend/accept/#{args.delete(:user_id)}"
        args[:verb] = :post
        api_call args
      end


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


      # http://untappd.com/api/docs/v4#add_comment
      # Required args: checkin_id, coment
      def add_comment(args)
        validate_api_args args, :checkin_id, :comment
        args[:endpoint] = "checkin/addcomment/#{args.delete(:checkin_id)}"
        args[:verb] = :post
        response = api_call args do |response|
          response.extract :response, :comments, :items
        end
      end


      # http://untappd.com/api/docs/v4#add_to_wish
      # Required args: beer_id
      def add_to_wish_list(args)
        validate_api_args args, :bid, :comment
        args[:endpoint] = '/user/wishlist/add'
        api_call args do |response|
          response.extract :response, :beer
        end
      end
      alias_method :add_to_wishlist, :add_to_wish_list


      def api_call(args)
        validate_api_args args, :endpoint
        args = @credential.merge(args)
        args[:verb] ||= :get
        args[:url] = find_path_at args.delete(:endpoint)
        args[:response_class] ||= self.class.default_response_class
        response = self.class.requestor.make_request(args)
        @rate_limit = self.class.default_rate_limit_class.new(response.headers)
        yield(response) if block_given?
        response
      end


      # http://untappd.com/api/docs/v4#beer_checkins
      # Required args: bid
      def beer_checkins(args)
        validate_api_args args, :bid
        args[:endpoint] = "beer/checkins/#{args.delete(:bid)}"
        api_call args do |response|
          response.extract :response, :checkins, :items
        end
      end
      alias_method :beer_feed, :beer_checkins


      # http://untappd.com/api/docs/v4#beer_info
      # Required args: bid
      def beer_info(args)
        validate_api_args args, :bid
        args[:endpoint] = "beer/info/#{args.delete(:bid)}"
        api_call args do |response|
          response.extract :response, :beer
        end
      end


      # http://untappd.com/api/docs/v4#beer_search
      # Required args: q
      def beer_search(args)
        validate_api_args args, :q
        args[:endpoint] = "search/beer"
        api_call args
      end


      # http://untappd.com/api/docs/v4#brewery_checkins
      # Required args: brewery_id
      def brewery_checkins(args)
        validate_api_args args, :brewery_id
        args[:endpoint] = "brewery/checkins/#{args.delete(:brewery_id)}"
        api_call args do |response|
          response.extract :response, :checkins, :items
        end
      end
      alias_method :brewery_feed, :brewery_checkins


      # http://untappd.com/api/docs/v4#brewery_info
      # Required args: brewery_id
      def brewery_info(args)
        validate_api_args args, :brewery_id
        args[:endpoint] = "brewery/info/#{args.delete(:brewery_id)}"
        endpoint = api_call args do |response|
          response.extract :response, :brewery
        end
      end


      # http://untappd.com/api/docs/v4#brewery_search
      # Required args: q
      def brewery_search(args)
        validate_api_args args, :q
        args[:endpoint] = "search/brewery"
        api_call args do |response|
          response.extract :response, :brewery, :items
        end
      end


      # http://untappd.com/api/docs/v4#details
      # Required args: checkin_id
      def checkin_info(args)
        validate_api_args :checkin_id
        args[:endpoint] = "checkin/view/#{args.delete(checkin_id)}"
        api_call args do |response|
          response.extract :response, :checkin
        end
      end


      # http://untappd.com/api/docs/v4#delete_comment
      # Required args: comment_id
      def delete_comment(args)
        validate_api_args :comment_id
        args[:endpoint] = "checkin/deletecomment/#{args.delete(comment_id)}"
        args[:verb] = :post
        api_call args do |response|
          response.extract :response, :comments
        end
      end
      alias_method :remove_comment, :delete_comment


      # http://untappd.com/api/docs/v4#foursquare_lookup
      # Required args: venue_id
      def foursquare_venue_info(args)
        validate_api_args :venue_id
        args[:endpoint] = "venue/foursquare_lookup/#{args.delete(venue_id)}"
        api_call args do |response|
          response.extract :response, :venue, :items, :first
        end
      end


      # http://untappd.com/api/docs/v4#feed
      def friend_feed(args={})
        args[:endpoint] = '/checkin/recent'
        api_call args do |response|
          response.extract :response, :checkins, :items
        end
      end


      def initialize(options={})
        @api_version = options[:api_version] || self.class.api_version
        @credential = self.class.default_credential_class.new(options)
        @server = options[:server] || self.class.server
      end


      # http://untappd.com/api/docs/v4#activity_on_you
      def news(args={})
        args[:endpoint] = :notifications
        api_call args do |response|
          response.extract :response, :news, :items
        end
      end


      # http://untappd.com/api/docs/v4#activity_on_you
      def notifications(args={})
        args[:endpoint] = :notifications
        api_call args do |response|
          response.extract :response, :notifications, :items
        end
      end


      # http://untappd.com/api/docs/v4#friend_pending
      def pending_friends(args={})
        args[:endpoint] = "user/pending"
        api_call args do |response|
          response.extract :response
        end
      end


      # http://untappd.com/api/docs/v4#friend_reject
      # Required args: user_id
      def reject_friend(args)
        validate_api_args args, :user_id
        args[:endpoint] = "friend/reject/#{args.delete(user_id)}"
        args[:verb] = :post
        api_call args
      end


      # http://untappd.com/api/docs/v4#friend_revoke
      # Required args: user_id
      def remove_friend(args)
        validate_api_args args, :user_id
        args[:endpoint] = "friend/remove/#{args.delete(user_id)}"
        api_call args
      end


      # http://untappd.com/api/docs/v4#remove_from_wish
      # Required args: bid
      def remove_from_wish_list(args)
        validate_api_args args, :bid
        args[:endpoint] = '/user/wishlist/remove'
        api_call args
      end
      alias_method :delete_from_wish_list, :remove_from_wish_list


      # http://untappd.com/api/docs/v4#friend_request
      # Required args: user_id
      def request_friend(arg)
        validate_api_args args, :user_id
        arg[:endpoint] = "friend/request/#{args.delete(:user_id)}"
        api_call args
      end


      # http://untappd.com/api/docs/v4#thepub
      def the_pub(args={})
        args[:endpoint] = :thepub
        api_call args do |response|
          response.extract :response, :checkins, :items
        end
      end


      # http://untappd.com/api/docs/v4#trending
      def trending(args)
        args[:endpoint] = '/beer/trending'
        api_call args
      end


      # http://untappd.com/api/docs/v4#toast
      # Required args: checkin_id
      def toast(args)
        validate_api_endpoint args, :checkin_id
        args[:endpoint] = "checkin/toast/#{args.delete(:checkin_id)}"
        api_call args
      end
      alias_method :delete_toast, :toast
      alias_method :add_toast, :toast


      # http://untappd.com/api/docs/v4#badges
      def user_badges(args={})
        args[:endpoint] = "user/badges/#{args.delete(:username)}"
        api_call args
      end


      # http://untappd.com/api/docs/v4#user_distinct
      def user_distinct_beers(args={})
        args[:endpoint] = "user/beers/#{args.delete(:username)}"
        api_call args do |response|
          response.extract :response, :beers, :items
        end
      end
      alias_method :user_beers, :user_distinct_beers


      # http://untappd.com/api/docs/v4#user_feed
      def user_feed(args={})
        args[:endpoint] = "user/checkins/#{args.delete(:username)}"
        api_call args do |response|
          response.extract :response, :checkins, :items
        end
      end


      # http://untappd.com/api/docs/v4#friends
      def user_friends(args={})
        args[:endpoint] = "user/friends/#{args.delete(:username)}"
        api_call args do |response|
          response.extract :response, :items
         end
      end


      # http://untappd.com/api/docs/v4#user_info
      def user_info(args={})
        args[:endpoint] = "user/info/#{args.delete(:username)}"
        api_call args do |response|
          response.extract :response, :user
        end
      end


      # http://untappd.com/api/docs/v4#wish_list
      def user_wish_list(args={})
        args[:endpoint] = "user/wishlist/#{args.delete(:username)}"
        api_call args do |response|
          response.extract :response, :beers, :items
        end
      end


      # http://untappd.com/api/docs/v4#venue_checkins
      # Required args: venue_id
      def venue_feed(args)
        validate_api_args args, :venue_id
        args[:endpoint] = "venue/checkins/#{args.delete(:venue_id)}"
        api_call args do |response|
          response.extract :response, :checkins, :items
        end
      end


      # http://untappd.com/api/docs/v4#venue_info
      def venue_info(args)
        validate_api_args args, :venue_id
        args[:endpoint] = "venue/info/#{args.delete(:venue_id)}"
        api_call args do |response|
          response.extract :response, :venue
        end
      end

    private

      def credential_string_for_url
        @credential.is_user? ? "?access_token=#{@credential.access_token}" : ""
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


      def validate_api_args(args, *required_args)
        raise ArgumentError.new("Please supply a hash") unless args.is_a?(Hash)
        required_args.each do |arg|
          raise ArgumentError.new("Missing required #{arg} parameter") unless !! args[arg]
        end
      end

    end
  end
end
