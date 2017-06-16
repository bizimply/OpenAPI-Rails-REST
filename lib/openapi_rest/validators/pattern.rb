module OpenAPIRest
  module Validators
    ###
    # Rest pattern validator
    #
    class Pattern
      def initialize(format, value)
        @format = format
        @value = value
      end

      def valid?
        Regexp.new(@format).match(@value)
      end

      def error(key)
        { key => "invalid format #{@format}" }
      end
    end
  end
end
