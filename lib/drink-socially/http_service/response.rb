module NRB
  module HTTPService
    class Response

      attr_reader :status, :body, :headers

      def errored?
        ! success?
      end


      def initialize(status, body, headers)
        @status = status
        @body = body
        @headers = headers
      end


      def success?
        @status >= 200 && @status < 300
      end

    end
  end
end
