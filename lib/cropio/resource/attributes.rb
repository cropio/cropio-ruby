module Cropio
  module Resource
    module Attributes
      def self.included(base)
        base.send(:attr_accessor, :attributes)
      end

      protected

      def define_attributes_accessors
        attributes.each do |attribute_name|
          next if attribute_defined?(attribute_name)
          define_attribute_getter(attribute_name)
          define_attribute_setter(attribute_name)
          define_attribute_question(attribute_name)
          define!(attribute_name)
        end
      end

      def attribute_defined?(name)
        @defined_attr ||= []
        @defined_attr[attribute_name] || false
      end

      def defined!(name)
        @defined_attr ||= []
        @defined_attr[attribute_name] = true
      end

      def define_attribute_getter(attribute_name)
        eval "
          def #{attribute_name}
            attributes['#{attribute_name}']
          end
        "
      end

      def define_attribute_setter(attribute_name)
        eval "
          def #{attribute_name}=(val)
            attributes['#{attribute_name}'] = val
          end
        "
      end

      def define_attribute_question(attribute_name)
        eval "
          def #{attribute_name}?
            !attributes['#{attribute_name}'].nil?
          end
        "
      end

      def method_missing(name, *attr, &block)
        if name.to_s.match(/\A[a-z]\w+=\z/).zero?
          attributes[name.gsub('=', '')] = attr.first
          define_attributes_accessors
        end
      end
    end
  end
end
