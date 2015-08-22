module Cropio
  # StringInflector contains operations for strings.
  # We think it is bad idea to require active_support for this.
  class StringInflector
    class << self
      def underscore(string)
        string
          .gsub(/::/, '/')
          .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
          .gsub(/([a-z\d])([A-Z])/, '\1_\2')
          .tr('-', '_')
          .downcase
      end

      # Returns pluralized form for word passed as param.
      # It is simple implementation - for resources plural forms only.
      def pluralize(string)
        if string[-1] == 'y'
          "#{string[0..(string.length - 2)]}ies"
        else
          "#{string}s"
        end
      end
    end
  end
end
