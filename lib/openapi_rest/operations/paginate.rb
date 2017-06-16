module OpenAPIRest
  module Operations
    ###
    # Rest paginate operation
    #
    class Paginate
      def initialize(query_builder)
        @query_builder = query_builder
      end

      def execute
        return if @query_builder.single?

        @query_builder.api_model.model = @query_builder.api_model.model.limit(@query_builder.limit)
                                                                       .offset(@query_builder.offset)
      end
    end
  end
end
