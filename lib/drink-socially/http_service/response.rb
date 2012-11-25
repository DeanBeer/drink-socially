require 'hashie'

module NRB
  class HTTPService
    class Response

      attr_reader :status, :body, :headers

      def errored?
        ! success?
      end


      def initialize(args)
        @status = args[:status]
        @body = Hashie::Mash.new args[:body]
        @headers = Hashie::Mash.new args[:headers]
      end


      def success?
        @status >= 200 && @status < 300
      end

    end
  end
end
