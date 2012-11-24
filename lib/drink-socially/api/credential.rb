require 'cgi'

module NRB
  module Untappd
    class API

    private

      class Credential

        class IncompleteCredentialError < RuntimeError; end

        def initialize(opts={})
          @creds = {}
          !! opts[:access_token]  && @creds[:access_token] = CGI::escape(opts[:access_token])
          !! opts[:client_id]     && @creds[:client_id] = CGI::escape(opts[:client_id])
          !! opts[:client_secret] && @creds[:client_secret] = CGI::escape(opts[:client_secret])
          raise IncompleteCredentialError.new('Provide either API access token or API client id & secret') unless valid?
        end

        [ :access_token, :client_id, :client_secret ].each do |m|
          define_method m do
            @creds[m]
          end
        end


        def is_client?
          !! @creds[:client_id] && !! @creds[:client_secret]
        end
        alias_method :is_app?, :is_client?


        def is_user?
          !! @creds[:access_token]
        end


        def merge(hash)
          @creds.merge(hash)
        end


        def to_h
          @creds
        end


        def to_param
          @creds.map { |k,v| "#{k}=#{v}" }.join("&")
        end

      private

        def valid?
          (is_client? || is_user?) && ! (is_client? && is_user?)
        end

      end

    end
  end
end
