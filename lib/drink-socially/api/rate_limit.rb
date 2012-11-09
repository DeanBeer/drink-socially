module NRB
  module Untappd
    class API
      class RateLimit

        attr_reader :limit, :remaining

        def initialize(headers)
          @limit     = headers["x-ratelimit-limit"]
          @remaining = headers["x-ratelimit-remaining"]
        end

      end
    end
  end
end
