module Cropio
  module Resource
    class Base
      include Attributes

      Proxy = Cropio::Connection::Proxy
      Limit = 1000

      def initialize(attributes={})
        self.attributes = attributes
      end

      def self.resource_name
        @resource_name ||= StringInflector.underscore(name.split('::').last)
      end

      def self.resources_name
        @resources_name ||= StringInflector.pluralize(resource_name)
      end

      def self.all
        to_instances(get_all_chunks)
      end

      def self.select(options={})
      end

      def persisted?
        !id.nil?
      end

      private
      def self.get_all_chunks(options={})
        response = nil
        buffer = []
        limit = options[:limit] || (2 ** 32 - 1)
        while is_data?(response) && limit > 0
          chunk_size = limit < Limit ? limit : Limit
          limit -= chunk_size
          offset = buffer.any? ? buffer.last['id'] + 1 : 0
          response = get_chunk(limit: chunk_size, from_id: offset)
          buffer += response['data']
        end
        buffer
      end

      def self.is_data?(response=nil)
        if response.nil?
          true
        else
          response['meta']['response']['obtained_records'].nonzero?
        end
      end

      def self.get_chunk(options)
        Proxy.get(resources_name, limit: options[:limit],
                    from_id: options[:from_id])
      end

      def self.to_instances(attr_sets)
        attr_sets.map do |attr_set|
          to_instance(attr_set)
        end
      end

      def self.to_instance(attr_set)
        new(attr_set)
      end
    end
  end
end
