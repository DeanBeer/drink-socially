module NRB
  module Untappd
    class API
      class Object < HTTPService::Response

        attr_reader :attributes, :error_message, :pagination, :results

        def initialize(args)
          super
          parse_error_response
          setup_pagination(args)
          extract_results args[:results_path]
        end

      private

        def define_attributes_from(hash)
          return unless hash.respond_to?(:keys)
          @attributes ||= []
          perform_unless_respond_to(hash.keys) do |attr|
            @attributes.push(attr.to_sym)
          end
        end


        def define_methods_from(hash)
          return unless hash.respond_to?(:keys)
          perform_unless_respond_to(hash.keys) do |meth|
            define_singleton_method meth, lambda { hash[meth] }
          end
        end


        def extract_from_body(path)
          return unless !! body
          path.inject(body) do |node,method_name|
            break unless node.respond_to? method_name
            node.send method_name
          end
        end


        def extract_results(path)
          @results = extract_from_body path if !! path
          define_attributes_from @results
          define_methods_from @results
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


        def perform_unless_respond_to(arr)
          return unless arr.respond_to?(:each)
          arr.each do |key|
            unless respond_to?(key)
              yield key
            end
          end
        end


        def setup_pagination(args)
          @paginator = args[:paginator_class] || NRB::Untappd::API::Pagination
          @pagination = @paginator.from_response self
        end

      end
    end
  end
end

