module OpenAPIRest
  ###
  # Rest Api Model
  #
  class ApiModel
    attr_reader :type
    attr_accessor :model

    def initialize(type)
      @type = type
      @model = type.to_s.capitalize!.constantize
    end

    def build(params, args = {}, &block)
      native_query(params.merge(operation: :create), args, &block)
    end

    def where(params, args = {}, &block)
      native_query(params.merge(operation: :query), args, &block)
    end

    def find(params, args = {}, &block)
      native_query(params.merge(operation: :squery), args, &block)
    end

    private

    def native_query(params, args)
      query_builder = OpenAPIRest::QueryBuilder.new(self, params.merge(query: args))

      yield(self) if block_given?

      query_builder.response
    end
  end
end
