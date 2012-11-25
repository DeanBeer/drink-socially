require 'drink-socially/http_service'
require 'drink-socially/version'
require 'drink-socially/extensions/hash'

module NRB
  module Untappd

    autoload :API,       'drink-socially/api'
    autoload :Config,    'drink-socially/config'

    class << self

      attr_accessor :http_service

      def config_file_path(key)
        return key if File.absolute_path(key) == key
        File.expand_path( File.join( config_dir, key ) )
      end


      def load_config(args)
        reader = args.delete(:config_reader) || Config
        !! args[:filekey] && args[:filename] = config_file_path(args.delete(:filekey))
        reader.new(args)
      end


      def make_request(args)
        http_service.make_request args
      end

    private

      def config_dir
        File.expand_path( File.join( File.dirname(__FILE__), '..', 'config' ) ) 
      end

    end

    self.http_service = HTTPService

  end
end
