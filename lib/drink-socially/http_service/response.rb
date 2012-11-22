module NRB
  module HTTPService
    class Response

      attr_reader :status, :body, :headers

      def errored?
        ! success?
      end


      def initialize(status, body, headers)
        @status = status
        @body = symbolify_hash_keys(body)
        @headers = headers
      end


      def success?
        @status >= 200 && @status < 300
      end

    private

      def symbolify_hash_keys(obj)
        return obj unless obj.is_a?(Hash) || obj.is_a?(Array)

        if obj.is_a?(Array)
          obj.each_with_index { |e,i| obj[i] = symbolify_hash_keys(e) }

        else
          obj.keys.each do |k|
            next if k.is_a?(Symbol)
            s = k.to_sym
            raise "Hash contains symbol & string key: #{k} #{obj[k]} #{obj[s]}" if !! obj[k] && !! obj[s]
            obj[s] = symbolify_hash_keys( obj.delete(k) )
          end

        end
        obj
      end

    end
  end
end
