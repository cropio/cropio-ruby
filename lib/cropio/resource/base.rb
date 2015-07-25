module Cropio
  module Resource
    class Base
      include Attributes

      Proxy = Cropio::Connection::Proxy

      def initialize(attributes={})
        @attributes = attributes
        define_attributes_accessors
      end

      def self.resource_name
        @resource_name ||= StringInflector.underscore(name.split('::').last)
      end

      def self.all

      end

      def self.select(options= {})
      end

      def persisted?
        !id.nil?
      end

      private
      def get_chunk
        Proxy.get(limit: options[:limit], from_id: options[:from_id])
      end

      def self.instatize

      end
    end
  end
end
