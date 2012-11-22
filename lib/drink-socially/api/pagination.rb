module NRB
  module Untappd
    class API
      class Pagination

        def self.from_response_body(body)
#          new(body[:response][:pagination]) if body[:response] && body[:response][:pagination]
        end


        def initialize(pagination)
          @max_id    = pagination[:max_id]
          @next_url  = pagination[:next_url]
          @since_url = pagination[:since_url]
        end

      end
    end
  end
end
