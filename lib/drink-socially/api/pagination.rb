require 'uri'
module NRB
  module Untappd
    class API
      class Pagination

        def self.from_response(response)
          # It's duck types (almost) all the way down
          return unless response.respond_to?(:body) &&
                        response.body.respond_to?(:response) &&
                        response.body.response.respond_to?(:pagination) &&
                        !! response.body.response.pagination
          new response.body.response.pagination
        end


        def initialize(pagination)
          @api_max_id = pagination[:max_id].to_i
          @uris   = { api_next: URI.parse(pagination[:next_url]),
                      api_prev: URI.parse(pagination[:since_url]),
                      api_since: URI.parse(pagination[:since_url])
                    }
        end


        def next_id
          @api_max_id + 1
        end


        # Warning: The API will return the most recent results if next_id is
        #          greater than the most recent result
        def next_uri
          uri_for query: "since=#{next_id}", uri: :next
        end


        def next_url
          next_uri.to_s
        end


        def prev_id
          @api_max_id - 1
        end
        alias_method :previous_id, :prev_id


        def prev_uri
          uri_for query: "max_id=#{prev_id}", uri: :prev
        end
        alias_method :previous_uri, :prev_uri


        def prev_url
          prev_uri.to_s
        end
        alias_method :previous_url, :prev_url

      private

        def uri_for(opts)
          return nil unless !! opts[:uri]
          return @uris[otps[:uri]] if @uris[opts[:uri]]
          @uris[otps[:uri]] = @uris["api_#{opts[:uri]}".to_sym]
          @uris[otps[:uri]].query = opts[:query] if opts[:query]
          @uris[otps[:uri]]
        end

      end
    end
  end
end
