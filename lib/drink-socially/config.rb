require 'yaml'

module NRB
  module Untappd
    class Config

      class NoConfig < ArgumentError; end

      extend Forwardable

      attr_reader :data

      def_delegators :@data, :[], :keys

      def initialize(args)
        load_data(args)
        define_accessors
      end

    private

      def define_accessors
        return unless @data
        @data.keys.each do |name|
          unless respond_to?(name)
            define_singleton_method name, lambda { data[name] }
          end
        end
      end


      def find_stream(args)
        if args[:filename]
          File.open args[:filename]
        end
      end


      def load_data(args)
        args[:stream] ||= find_stream(args)
        raise NoConfig.new("Please supply :filename or :stream to Config.new") unless !! args[:stream]
        loader = args[:stream_loader] || YAML
        @data = loader.load_stream(args[:stream])[0]
      end

    end
  end
end
