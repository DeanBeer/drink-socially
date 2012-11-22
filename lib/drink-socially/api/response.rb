module NRB
  module Untappd
    class API
      class Response < HTTPService::Response

        attr_reader :error_message, :pagination

        def initialize(status, body, headers)
          super
          symbolify_hash_keys(@body)
          @error_message = if body[:meta]
            "[#{body[:meta][:error_type]}] #{body[:meta][:error_detail]}"

          elsif body[:error]
            body[:error]
          else
            "Unrecognized response"
          end
          @pagination = Pagination.from_response_body @body
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
end

