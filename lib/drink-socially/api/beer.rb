module NRB
  module Untappd
    class API
      module Beer

        # http://untappd.com/api/docs/v4#beer_checkins
        def beer_checkins(beer_id, args={})
          beer_api_call :checkins, beer_id, args
        end


        # http://untappd.com/api/docs/v4#beer_info
        def beer_info(beer_id, args={})
          beer_api_call :get, :info, beer_id, args
        end


        def trending(args={})
          beer_api_call :trending, nil, args
        end

      private

        def beer_api_call(endpoint, beer_id, args)
          api_call :get, "/beer/#{endpoint}/#{beer_id}", args
        end

      end
    end
  end
end
