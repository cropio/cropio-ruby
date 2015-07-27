module Cropio
  class StringInflector
    class << self
      def underscore(string)
        string
          .gsub(/::/, '/')
          .gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2')
          .gsub(/([a-z\d])([A-Z])/,'\1_\2')
          .tr("-", "_")
          .downcase
      end

      # simple implementation - for resources plural form only
      def pluralize(string)
        if string[-1] == 'y'
          "#{ string[0..(string.length - 2)] }ies"
        else
          "#{ string }s"
        end
      end
    end
  end
end
