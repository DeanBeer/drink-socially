module NRB
  module Untappd
    class API
      class Response < HTTPService::Response

        attr_reader :error_message, :pagination

        def initialize(status, body, headers)
          super
          parse_error_response
          @pagination = Pagination.from_response self
        end

      private

        def parse_error_response
          return unless errored?
          @error_message = if body[:meta]
            "[#{body[:meta][:error_type]}] #{body[:meta][:error_detail]}"

          elsif body[:error]
            body[:error]

          else
            "Could not parse error message from response body"
          end
        end

      end
    end
  end
end

