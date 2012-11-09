module NRB
  module Untappd
    class API
      class Pagination

        def self.from_response_body(body)
          new(body[:response][:pagination]) if body[:response] && body[:response][:pagination]
        end


        def initialize(pagination)
        end

      end
    end
  end
end
