module OpenAPIRest
  module Validators
    ###
    # Rest format validator
    #
    class Format
      def initialize(format, value)
        @format = format
        @value = value
      end

      def valid?
        return @value.is_a?(Numeric) if @format == 'int64' || @format == 'int32'
        return !DateTimeHelper.in_utc(@value).nil? if @format == 'date-time'

        true
      end

      def error(key)
        { key => "not a #{@format}" }
      end
    end
  end
end
