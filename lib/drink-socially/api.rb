module NRB
  module Untappd
    class API

      API_VERSION = 'v4'          # Use NRB::Untappd::API.api_version instead
      SERVER = 'api.untappd.com'  # Use NRB::Untappd::API.server instead

      autoload :Credential, 'drink-socially/api/credential'
      autoload :Pagination,  'drink-socially/api/pagination'
      autoload :RateLimit,   'drink-socially/api/rate_limit'
      autoload :Response,    'drink-socially/api/response'

      attr_reader :credential, :rate_limit, :response

      def self.api_version; API_VERSION; end
      def self.default_credential_class; Credential; end
      def self.default_rate_limit_class; RateLimit; end
      def self.default_response_class; Response; end
      def self.server; SERVER; end


      # http://untappd.com/api/docs/v4#friend_accept
      def accept_friend(user_id, args={})
        api_call :post, "friend/accept/#{user_id}", args
      end


      # http://untappd.com/api/docs/v4#checkin
      def add_checkin(beer_id, args={})
        t = Time.now
        args[:bid] = beer_id
        args[:gmt_offset] ||= t.gmt_offset / 3600
        args[:timezone] ||= t.zone
        api_call :post, 'checkin/add', args
      end


      # http://untappd.com/api/docs/v4#add_comment
      def add_comment(checkin_id, comment, args={})
        args[:comment] = comment
        api_call :post, "checkin/addcomment/#{checkin_id}", args
      end


      # http://untappd.com/api/docs/v4#add_to_wish
      def add_to_wish_list(beer_id, args={})
        args[:bid] = beer_id
        api_call :get, '/user/wishlist/add', args
      end


      # http://untappd.com/api/docs/v4#toast
      def add_toast(checkin_id, args={})
        api_call :get, "checkin/toast/#{checkin_id}", args
      end
      alias_method :delete_toast, :add_toast
      alias_method :toast, :add_toast


      def api_call(verb, endpoint, args={})
        path = find_path_at(endpoint)
        args = @credential.merge(args)

        response = NRB::Untappd.make_request(verb, path, args)
        @rate_limit = self.class.default_rate_limit_class.new(response.headers)
        @response = self.class.default_response_class.new(response.status.to_i, response.body, response.headers)
      end


      # http://untappd.com/api/docs/v4#beer_checkins
      def beer_checkins(beer_id, args={})
        api_call :get, "beer/checkins/#{beer_id}", args
      end
      alias_method :beer_feed, :beer_checkins


      # http://untappd.com/api/docs/v4#beer_info
      def beer_info(beer_id, args={})
        api_call :get, "beer/info/#{beer_id}", args
      end


      # http://untappd.com/api/docs/v4#beer_search
      def beer_search(query, args={})
        args[:q] = query
        api_call :get, "search/beer", args
      end


      # http://untappd.com/api/docs/v4#brewery_checkins
      def brewery_checkins(brewery_id, args={})
        api_call :get, "brewery/checkins/#{brewery_id}", args
      end
      alias_method :brewery_feed, :brewery_checkins


      # http://untappd.com/api/docs/v4#brewery_info
      def brewery_info(brewery_id, args={})
        api_call :get, "brewery/info/#{brewery_id}", args
      end


      # http://untappd.com/api/docs/v4#brewery_search
      def brewery_search(query, args={})
        args[:q] = query
        api_call :get, "search/brewery", args
      end


      # http://untappd.com/api/docs/v4#details
      def checkin_info(checkin_id, args={})
        api_call :get, "checkin/view/#{checkin_id}", args
      end


      # http://untappd.com/api/docs/v4#delete_comment
      def delete_comment(comment_id, args={})
        api_call :post, "checkin/deletecomment/#{comment_id}", args
      end
      alias_method :remove_comment, :delete_comment


      # http://untappd.com/api/docs/v4#foursquare_lookup
      def foursquare_venue_info(venue_id, args={})
        api_call :get, "venue/foursquare_lookup/#{venue_id}", args
      end


      # http://untappd.com/api/docs/v4#feed
      def friend_feed(args={})
        api_call :get, '/checkin/recent', args
      end


      def initialize(options={})
        @credential = self.class.default_credential_class.new(options)
        @error = nil
      end


      # http://untappd.com/api/docs/v4#activity_on_you
      def notifications(args={})
        api_call :get, "notifications", args
      end


      # http://untappd.com/api/docs/v4#friend_pending
      def pending_friends(args={})
        api_call :get, "user/pending", args
      end


      # http://untappd.com/api/docs/v4#friend_reject
      def reject_friend(user_id, args={})
        api_call :post, "friend/reject/#{user_id}", args
      end


      # http://untappd.com/api/docs/v4#friend_revoke
      def remove_friend(user_id, args={})
        api_call :get, "friend/remove/#{user_id}", args
      end


      # http://untappd.com/api/docs/v4#remove_from_wish
      def remove_from_wish_list(beer_id, args={})
        args[:bid] = beer_id
        api_call :get, '/user/wishlist/remove', args
      end
      alias_method :delete_from_wish_list, :remove_from_wish_list


      # http://untappd.com/api/docs/v4#friend_request
      def request_friend(user_id, args={})
        api_call :get, "friend/request/#{user_id}", args
      end


      # http://untappd.com/api/docs/v4#thepub
      def the_pub(args={})
        api_call :get, '/thepub', args
      end


      # http://untappd.com/api/docs/v4#trending
      def trending(args={})
        api_call :get, '/beer/trending', args
      end


      # http://untappd.com/api/docs/v4#badges
      def user_badges(username, args={})
        api_call :get, "user/badges/#{username}", args
      end


      # http://untappd.com/api/docs/v4#user_distinct
      def user_distinct_beers(username=nil, args={})
        api_call :get, "user/beers/#{username}", args
      end
      alias_method :user_beers, :user_distinct_beers


      # http://untappd.com/api/docs/v4#user_feed
      def user_feed(username=nil, args={})
        api_call :get, "user/checkins/#{username}", args
      end


      # http://untappd.com/api/docs/v4#friends
      def user_friends(username=nil, args={})
        api_call :get, "user/friends/#{username}", args
      end


      # http://untappd.com/api/docs/v4#user_info
      def user_info(username, args={})
        api_call :get, "user/info/#{username}", args
      end


      # http://untappd.com/api/docs/v4#wish_list
      def user_wish_list(username=nil, args={})
        api_call :get, "user/wishlist/#{username}", args
      end


      # http://untappd.com/api/docs/v4#venue_checkins
      def venue_feed(venue_id, args={})
        api_call :get, "venue/checkins/#{venue_id}", args
      end


      # http://untappd.com/api/docs/v4#venue_info
      def venue_info(venue_id, args={})
        api_call :get, "venue/info/#{venue_id}", args
      end

    private

      def extract_info_from(response, *keys)
        return unless response.success?
        keys.inject(response.body) { |hash, key| hash[key] }
      end


      def find_path_at(endpoint)
        if @credential.is_user?
          "http://#{API.server}/#{API.api_version}/#{endpoint}?access_token=#{@credential.access_token}"
        else
          "http://#{API.server}/#{API.api_version}/#{endpoint}"
        end
      end

    end
  end
end
