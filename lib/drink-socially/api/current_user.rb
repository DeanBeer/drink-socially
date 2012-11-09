module NRB
  module Untappd
    class API
      module CurrentUser

        # http://untappd.com/api/docs/v4#activity_on_you
        # http://untappd.com/api/docs/v4#add_to_wish
        # http://untappd.com/api/docs/v4#add_comment
        # http://untappd.com/api/docs/v4#checkin
        # http://untappd.com/api/docs/v4#delete_comment
        # http://untappd.com/api/docs/v4#friend_accept
        # http://untappd.com/api/docs/v4#friend_pending
        # http://untappd.com/api/docs/v4#friend_reject
        # http://untappd.com/api/docs/v4#friend_request
        # http://untappd.com/api/docs/v4#friend_revoke
        # http://untappd.com/api/docs/v4#remove_from_wish
        # http://untappd.com/api/docs/v4#toast

        # http://untappd.com/api/docs/v4#feed
        def friend_feed(args={})
          api_call :get, "/checkin/recent", args
        end

      end
    end
  end
end
