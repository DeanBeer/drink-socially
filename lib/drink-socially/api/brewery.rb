module NRB
  module Untappd
    class API
      module Brewery

        # http://untappd.com/api/docs/v4#brewery_checkins
        def brewery_checkins(brewery_id, args={})
          brewery_api_call :checkins, brewery_id, args
        end

        # http://untappd.com/api/docs/v4#brewery_info
        def brewery_info(brewery_id, args={})
          brewery_api_call :get, :info, brewery_id, args
        end

      private

        def brewery_api_call(endpoint, brewery_id, args)
          api_call :get, "/brewery/#{endpoint}/#{brewery_id}", args
        end

      end
    end
  end
end
