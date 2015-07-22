module Cropio
  module Resource
    module Attributes
      def self.included(base)
        base.send(:attr_accessor, :attributes)
      end

      protected

      def define_attributes_accessors
        attributes.each do |attribute_name|
          define_attribute_getter(attribute_name)
          define_attribute_setter(attribute_name)
          define_attribute_question(attribute_name)
        end
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
            attributes['#{attribute_name}'].present?
          end
        "
      end
    end
  end
end
