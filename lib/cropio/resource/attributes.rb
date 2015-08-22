module Cropio
  module Resource
    # Defines accessors for resource attrubutes.
    module Attributes
      def self.included(base)
        base.send(:attr_accessor, :attributes)
      end

      protected

      def attributes
        @attributes ||= {}
      end

      def attributes=(val)
        @attributes = val
      end

      def define_attributes_accessors
        attributes.each_key do |attribute_name|
          next if attribute_defined?(attribute_name)
          define_attribute_getter(attribute_name)
          define_attribute_setter(attribute_name)
          define_attribute_question(attribute_name)
          defined!(attribute_name)
        end
      end

      def attribute_defined?(attribute_name)
        @defined_attr ||= {}
        @defined_attr[attribute_name] ||= false
      end

      def defined!(attribute_name)
        @defined_attr ||= {}
        @defined_attr[attribute_name] = true
      end

      def define_attribute_getter(attribute_name)
        instance_eval "
          def #{attribute_name}
            attributes['#{attribute_name}']
          end
        "
      end

      def define_attribute_setter(attribute_name)
        instance_eval "
          def #{attribute_name}=(val)
            attributes['#{attribute_name}'] = val
          end
        "
      end

      def define_attribute_question(attribute_name)
        instance_eval "
          def #{attribute_name}?
            !attributes['#{attribute_name}'].nil?
          end
        "
      end

      def method_missing(name, *attrs, &block)
        name = name.to_s
        attr_name = name.delete('=')
        if attributes.key?(attr_name)
          define_attributes_accessors
          name == attr_name ? send(name) : send(name, attrs.first)
        else
          super
        end
      end
    end
  end
end
