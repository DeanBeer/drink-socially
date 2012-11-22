module NRB
  class HTTPService
    class Response

      attr_reader :status, :body, :headers

      def errored?
        ! success?
      end


      def initialize(status, body, headers)
        @status = status
        @body = body.nrb_symbolify
        @headers = headers
      end


      def success?
        @status >= 200 && @status < 300
      end

    end
  end
end
