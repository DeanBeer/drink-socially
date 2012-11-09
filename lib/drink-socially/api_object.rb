module NRB
  module Untappd
    class APIObject

      def self.attrs; []; end

      def self.setup_instance_variables
        instance_eval do
          attr_reader *attrs
        private
            attr_writer *attrs
        end
      end


      def initialize(hash)
        self.class.attrs.each { |a| send("#{a}=", hash[a]) }
      end

    end
  end
end
