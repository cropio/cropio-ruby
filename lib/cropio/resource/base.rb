module Cropio
  module Resource
    class Base
      include Attributes

      def initialize(attributes)
        @attributes = attributes
        define_attributes_accessors
      end
    end
  end
end
