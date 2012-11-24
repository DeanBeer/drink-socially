module NRB
  module Untappd
    class API
      class Object < HTTPService::Response

        def self.default_pagination_class; NRB::Untappd::API::Pagination; end

        attr_reader :attributes, :error_message, :pagination, :results


        def extract(*path)
          @results = drill_into_body(path)
          define_attributes_from(@results)
          define_methods_from(@results)
          @results
        end


        def initialize(status, body, headers)
          super
          parse_error_response
          @pagination = self.class.default_pagination_class.from_response self
        end

      private

        def define_attributes_from(hash)
          @attributes ||= []
          perform_if_hash(hash) do |attr|
            @attributes.push(attr.to_sym)
          end
        end


        def define_methods_from(hash)
          perform_if_hash(hash) do |meth|
            instance_eval %Q{ def #{meth}; #{hash[meth]}; end }
          end
        end


        def perform_if_hash(hash)
          return unless hash.respond_to?(:keys)
          hash.keys.each do |key|
            unless respond_to?(key)
              yield key
            end
          end
        end


        def drill_into_body(path)
          if !! body
            path.inject(body) do |node,method_name|
              break unless node.respond_to? method_name
              node.send method_name
            end
          end
        end


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

