module OpenAPIRest
  module Operations
    ###
    # Rest sort operation
    #
    class Sort
      def initialize(query_builder)
        @query_builder = query_builder
      end

      def execute
        return if @query_builder.single? || !@query_builder.sort.present?

        sorts = @query_builder.sort.split(',')
        order = sorts.map do |s|
          if URI.encode_www_form_component(s)[0] == '+'
            "#{s[1..s.length]} ASC"
          else
            "#{s[1..s.length]} DESC"
          end
        end.join(',')

        @query_builder.api_model.model = @query_builder.api_model.model.order(order)
      end
    end
  end
end
