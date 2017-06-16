module OpenAPIRest
  ###
  # Api doc parser based on OpenAPI specs
  #
  module ApiDoc
    @config = nil

    class << self
      def configure
        yield config = OpenAPIRest::ApiConfig.new
        @config = config
      end

      def document
        @config.document
      end
    end
  end
end
