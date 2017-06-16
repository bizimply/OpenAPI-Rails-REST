module OpenAPIRest
  module Operations
    ###
    # Rest filter operation
    #
    class Filter
      def initialize(query_builder)
        @query_builder = query_builder
      end

      def execute
        return if @query_builder.query.count.zero?

        unlocked_params = ActiveSupport::HashWithIndifferentAccess.new(@query_builder.query)

        @query_builder.api_model.model = if @query_builder.single?
                                           @query_builder.api_model.model.find_by(unlocked_params)
                                         else
                                           @query_builder.api_model.model.where(unlocked_params)
                                         end
      end
    end
  end
end
