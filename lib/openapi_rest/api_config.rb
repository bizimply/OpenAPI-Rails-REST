module OpenAPIRest
  ###
  # Api doc config based on OpenAPI specs
  #
  class ApiConfig
    attr_accessor :document

    def initialize(user_config = {})
      self.document = user_config[:document]
    end
  end
end
