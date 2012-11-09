require 'drink-socially/user'
module NRB
  module Untappd
    class API
      module User

        # http://untappd.com/api/docs/v4#badges
        def user_badges(user=nil, args={})
          response = user_api_call :badges, user, args
          extract_user_info(response, :response, :items)
        end


        # http://untappd.com/api/docs/v4#user_distinct
        def user_beers(user=nil, args={})
          response = user_api_call :beers, user, args
          extract_user_info(response, :response, :beers, :items)
        end
        alias_method :user_distinct_beers, :user_beers


        # http://untappd.com/api/docs/v4#user_feed
        def user_feed(user=nil, args={})
          response = user_api_call :checkins, user, args
          extract_user_info(response, :response, :checkins, :items)
        end


        # http://untappd.com/api/docs/v4#friends
        def user_friends(user=nil, args={})
          response = user_api_call :friends, user, args
          extract_user_info(response, :response, :items)
        end


        # http://untappd.com/api/docs/v4#user_info
        def user_info(user=nil, args={})
          response = user_api_call :info, user, args
          NRB::Untappd::User.new(extract_user_info(response, :response, :user)) if response.success?
        end


        # http://untappd.com/api/docs/v4#wish_list
        def user_wish_list(user=nil, args={})
          response = user_api_call :wishlist, user, args
          extract_user_info(response, :response, :beers, :items)
        end

      private

        def extract_user_info(response,*keys)
          return unless response.success?
          keys.inject(response.body) { |hash, key| hash[key] }
        end


        def user_api_call(endpoint, user, args)
          api_call :get, "/user/#{endpoint}/#{user}", args
        end

      end
    end
  end
end
