module OpenAPIRest
  ###
  # Rest api validator
  #
  class ApiValidator
    def initialize(parameter)
      @parameter = parameter
    end

    def evaluate(key, value)
      if @parameter['format'].present?
        validator = OpenAPIRest::Validators::Format.new(@parameter['format'], value[key])
        return validator.error(key) unless validator.valid?
      elsif @parameter['pattern'].present?
        validator = OpenAPIRest::Validators::Pattern.new(@parameter['pattern'], value[key])
        return validator.error(key) unless validator.valid?
      end
    end
  end
end
