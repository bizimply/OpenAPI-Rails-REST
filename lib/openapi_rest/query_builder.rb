module OpenAPIRest
  ###
  # Rest Query Builder
  #
  class QueryBuilder
    attr_reader :query
    attr_reader :sort
    attr_reader :limit
    attr_reader :offset
    attr_reader :fields
    attr_reader :api_model
    attr_reader :params
    attr_reader :openapi_path

    def initialize(api_model, params)
      @fields = params.fetch(:fields, '')
      @offset = params.fetch(:offset, 0)
      @limit = params.fetch(:limit, 10)
      @sort = params[:sort]
      @embed = params[:embed]
      @query = params.fetch(:query, {})
      @openapi_path = params.fetch(:openapi_path)
      @single = params[:operation] == :squery
      @params = params
      @api_model = api_model

      set_fields

      unless creating?
        [OpenAPIRest::Operations::Filter.new(self),
         OpenAPIRest::Operations::Sort.new(self),
         OpenAPIRest::Operations::Paginate.new(self)].each { |operations| operations.execute }
      end
    end

    def response
      @response ||= OpenAPIRest::QueryResponse.new(self)
      @response
    end

    def single_result?
      creating? || @single
    end
    alias_method :single?, :single_result?

    def resource
      entity.to_s.singularize
    end

    def entity
      @api_model.type.to_s.downcase.pluralize
    end

    def raw_model
      @api_model.model
    end

    private

    def creating?
      @params[:operation] == :create
    end

    def set_fields
      permitted = OpenAPIRest::ApiParameters.new(api_model: @api_model,
                                                 openapi_path: @openapi_path).response_permitted_params
      @fields = fields.length > 0 ? fields.split(',').select { |s| permitted.include?(s.to_sym) } : permitted
    end
  end
end
