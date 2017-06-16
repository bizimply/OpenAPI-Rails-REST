module OpenAPIRest
  ###
  # Rest Api Parameters
  #
  class ApiParameters
    attr_reader :allowed_params, :validation_errors

    def initialize(args)
      @params = args.fetch(:params, {})
      @model_class = args.fetch(:api_model).model
      @doc_parser = OpenAPIRest::ApiDocParser.new(args.fetch(:openapi_path, {}))
    end

    def valid?
      @validation_errors = []

      validate

      @validation_errors.empty?
    end

    def response_permitted_params
      @doc_parser.find_path.responses.find(response_code).schema.properties.keys.collect(&:to_sym)
    end

    private

    def response_code
      return 204 if @doc_parser.method.to_sym == :patch || @doc_parser.method.to_sym == :delete
      return 201 if @doc_parser.method.to_sym == :post
      200
    end

    def validate
      if !@params.include?(property_param) || @params[property_param].empty?
        @validation_errors << ["Missing Parameter: #{property_param}"]
        return @validation_errors
      end

      @allowed_params = @params.require(property_param).permit(save_permitted_params)
      @validation_errors = @allowed_params.keys.map do |key|
        OpenAPIRest::ApiValidator.new(root_parameters[key.to_s]).evaluate(key, @allowed_params)
      end.compact
    end

    def save_permitted_params
      root_parameters.keys.collect(&:to_sym)
    end

    def root_parameters
      params = @doc_parser.find_path.find_parameters
      puts 'ERROR: parameters not found' if params.nil?
      params
    end

    def property
      @model_class.name.demodulize
    end

    def property_param
      if @model_class.name.nil?
        @model_class.class.name.demodulize.downcase.to_sym
      else
        @model_class.name.demodulize.downcase.to_sym
      end
    end

    def api_parameters(key)
      @doc_parser.document.parameters.find(key)
    end

    def api_definitions(key)
      @doc_parser.document.definitions.find(key)
    end
  end
end
