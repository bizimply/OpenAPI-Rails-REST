module OpenAPIRest
  ###
  # Rest Query Response
  #
  class QueryResponse
    attr_reader :query_builder
    attr_reader :errors

    delegate :single?, to: :query_builder
    delegate :resource, to: :query_builder
    delegate :entity, to: :query_builder
    delegate :fields, to: :query_builder

    def initialize(query_builder)
      @query_builder = query_builder
      @errors = []
    end

    def create_resource
      @operation = :post

      api_params = OpenAPIRest::ApiParameters.new(api_model: @query_builder.api_model,
                                                  params: @query_builder.params,
                                                  openapi_path: @query_builder.openapi_path)
      unless api_params.valid?
        @errors = api_params.validation_errors
        return
      end

      create_params = api_params.allowed_params.merge!(@query_builder.query)
      @model = @query_builder.raw_model.new(create_params)

      return if @model.valid? && @model.save

      build_errors
    end

    def update_resource
      @operation = :patch

      api_params = OpenAPIRest::ApiParameters.new(api_model: @query_builder.api_model,
                                                  params: @query_builder.params,
                                                  openapi_path: @query_builder.openapi_path)

      unless api_params.valid?
        @errors = api_params.validation_errors
        return
      end

      @model = @query_builder.raw_model

      return if !@model.nil? && @model.update(api_params.allowed_params)

      build_errors
    end

    def delete_resource
      @operation = :delete
      @model = @query_builder.raw_model
      return if !@model.nil? && @model.destroy

      build_errors
    end

    def results?
      if single?
        !results.nil?
      else
        results.count > 0
      end
    end

    def results
      @model ||= @query_builder.raw_model
    end

    def errors?
      !@errors.empty?
    end

    private

    def build_errors
      return if @model.nil?

      @errors = @model.errors.keys.map { |k| { k => @model.errors[k].first } }
    end
  end
end
