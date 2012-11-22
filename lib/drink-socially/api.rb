# Missing API Calls
#   Checkin http://untappd.com/api/docs/v4#checkin
#   Add Comment http://untappd.com/api/docs/v4#add_comment

module NRB
  module Untappd
    class API

      API_VERSION = 'v4'          # Use NRB::Untappd::API.api_version instead
      SERVER = 'api.untappd.com'  # Use NRB::Untappd::API.server instead

      autoload :Credentials, 'drink-socially/api/credentials'
      autoload :Pagination,  'drink-socially/api/pagination'
      autoload :RateLimit,   'drink-socially/api/rate_limit'
      autoload :Response,    'drink-socially/api/response'

      attr_reader :credentials, :rate_limit, :response


      def self.api_version; API_VERSION; end
      def self.server; SERVER; end


      def accept_friend(user_id, args={})
        api_call :post, "friend/accept/#{user_id}", args
      end


      def api_call(verb, endpoint, args={})
        path = find_path_at(endpoint)
        args = @credentials.merge(args)

        response = NRB::Untappd.make_request(verb, path, args)
        @rate_limit = RateLimit.new(response.headers)
        @response = Response.new(response.status.to_i, response.body, response.headers)
      end


      def beer_checkins(beer_id, args={})
        api_call :get, "beer/checkins/#{beer_id}", args
      end
      alias_method :beer_feed, :beer_checkins


      def beer_info(beer_id, args={})
        api_call :get, "beer/info/#{beer_id}", args
      end


      def beer_search(query, args={})
        args[:q] = query
        api_call :get, "search/beer", args
      end


      def brewery_feed(brewery_id, args={})
        api_call :get, "brewery/checkins/#{brewery_id}", args
      end


      def brewery_info(brewery_id, args={})
        api_call :get, "brewery/info/#{brewery_id}", args
      end


      def brewery_search(query, args={})
        args[:q] = query
        api_call :get, "search/brewery", args
      end


      def checkin_info(checkin_id, args={})
        api_call :get, "checkin/view/#{checkin_id}", args
      end


      def create_checkin(beer_id, args={})
        args[:bid] = beer_id
        api_call :post, 'checkin/add', args
      end


      def foursquare_venue_info(venue_id, args={})
        api_call :get, "venue/foursquare_lookup/#{venue_id}", args
      end


      def friend_feed(args={})
        api_call :get, '/checkin/recent', args
      end


      def initialize(options={})
        @credentials = Credentials.new(options)
        @error = nil
      end


      def notifications(args={})
        api_call :get, "notifications", args
      end


      def pending_friends(args={})
        api_call :get, "user/pending", args
      end


      def reject_friend(user_id, args={})
        api_call :post, "friend/reject/#{user_id}", args
      end


      def remove_comment(comment_id, args={})
        api_call :post, "checkin/deletecomment/#{comment_id}", args
      end


      def remove_friend(user_id, args={})
        api_call :get, "friend/remove/#{user_id}", args
      end


      def remove_wishlist_beer(beer_id, args={})
        args[:bid] = beer_id
        api_call :get, '/user/wishlist/remove', args
      end


      def request_friend(user_id, args={})
        api_call :get, "friend/request/#{user_id}", args
      end


      def the_pub(args={})
        api_call :get, '/thepub', args
      end


      def toast(checkin_id, args={})
        api_call :get, "checkin/toast/#{checkin_id}", args
      end


      def trending(args={})
        api_call :get, '/beer/trending', args
      end


      def user_badges(username, args={})
        api_call :get, "user/badges/#{username}", args
      end


      def user_beers(username=nil, args={})
        api_call :get, "user/beers/#{username}", args
      end
      alias_method :user_distinct_beers, :user_beers


      def user_feed(username=nil, args={})
        api_call :get, "user/checkins/#{username}", args
      end


      def user_friends(username=nil, args={})
        api_call :get, "user/friends/#{username}", args
      end


      def user_info(username, args={})
        api_call :get, "user/info/#{username}", args
      end


      def user_wishlist(username=nil, args={})
        api_call :get, "user/wishlist/#{username}", args
      end


      def venue_feed(venue_id, args={})
        api_call :get, "venue/checkins/#{venue_id}", args
      end


      def venue_info(venue_id, args={})
        api_call :get, "venue/info/#{venue_id}", args
      end


      def wishlist_beer(beer_id, args={})
        args[:bid] = beer_id
        api_call :get, '/user/wishlist/add', args
      end

    private

      def extract_info_from(response, *keys)
        return unless response.success?
        keys.inject(response.body) { |hash, key| hash[key] }
      end


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
