module Cropio
  module Resource
    # Represents ActiveRecord::Base-like model's class
    # with Cropio data selection and mutation.
    class Base
      include Attributes

      PROXY = Cropio::Connection::Proxy
      LIMIT = 1000

      TO_TIME = DateTime.new(2100)

      def initialize(attributes = {})
        self.attributes = attributes
      end

      # Returns name of Resource
      def self.resource_name
        @resource_name ||= StringInflector.underscore(name.split('::').last)
      end

      # Return pluralized version of Resource's name
      def self.resources_name
        @resources_name ||= StringInflector.pluralize(resource_name)
      end

      # Get all resources.
      def self.all
        to_instances(get_all_chunks)
      end

      # Count all resources.
      def self.count
        all.count
      end

      def self.changes(from_time, to_time = TO_TIME)
        to_instances(get_all_changes(from_time, to_time))
      end

      # Returns persistance of the resource.
      # Resource is persisted if it is saved
      # and not deleted, if this resource exists
      # on Cropio servers.
      def persisted?
        @persisted.nil? && (@persisted ||= false)
      end

      # Saves current resource to Cropio.
      def save
        self.attributes =
          if persisted?
            PROXY.patch("#{resources_name}/#{id}", attributes)
          else
            @persisted = true
            PROXY.post(resources_name, attributes)
          end
      end

      # Remove this resource from Cropio.
      def destroy
        if persisted?
          PROXY.delete("#{resources_name}/#{id}")
          @persisted = false
          true
        else
          fail 'Cropio record is not persisted!'
        end
      end

      private

      # Returns pluralized name of own type.
      def resources_name
        self.class.resources_name
      end

      # Download resources from Cropio by Chunks.
      def self.get_all_chunks(options = {})
        response = nil
        buffer = []
        limit = options[:limit] || (2**32 - 1)
        while data?(response) && limit > 0
          limit -= limit < LIMIT ? limit : LIMIT
          response = get_chunk(limit: limit, from_id: offset(buffer))
          buffer += response['data']
        end
        buffer
      end

      def self.get_all_changes(from_time, to_time)
        response = nil
        buffer = []
        limit = 2**32 - 1
        while data?(response) && limit > 0
          response = get_changes(limit: limit,
                                 from_time: from_time,
                                 to_time: to_time)
          limit -= limit < LIMIT ? limit : LIMIT
          to_time = last_record_time(response) || from_time
          buffer += response['data']
        end
        buffer
      end

      def self.last_record_time(response)
        response['meta']['response']['last_record_time']
      end

      # Gets offset for next chunk during download.
      def self.offset(buffer)
        buffer.any? ? buffer.last['id'] + 1 : 0
      end

      # Returns false if chunk is not empty.
      def self.data?(response = nil)
        if response.nil?
          true
        else
          response['meta']['response']['obtained_records'].nonzero?
        end
      end

      # Download chunk from Cropio.
      def self.get_chunk(options)
        PROXY.get(resources_name,
                  limit: options[:limit],
                  from_id: options[:from_id])
      end

      def self.get_changes(options)
        PROXY.changes(resources_name,
                      limit: options[:limit],
                      from_time: options[:from_time],
                      to_time: options[:to_time])
      end

      # Converts each received attribute's hash to resources.
      def self.to_instances(attr_sets)
        attr_sets.map do |attr_set|
          to_instance(attr_set)
        end
      end

      # Converts specified attribute's hash to resource.
      def self.to_instance(attr_set)
        new(attr_set).tap do |resource|
          resource.instance_eval do
            @persisted = true
          end
        end
      end
    end
  end
end
