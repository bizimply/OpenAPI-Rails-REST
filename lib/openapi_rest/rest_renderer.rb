module OpenAPIRest
  ###
  # Rest Response Renderer
  #
  class RestRenderer
    attr_reader :controller
    attr_reader :response

    def initialize(args)
      @controller = args[:controller]
      @response = args[:response]
    end

    def render
      unless response.is_a?(OpenAPIRest::QueryResponse)
        controller.render(response)
        return
      end

      return controller.render(error_response) if response.errors?

      method = controller.request.request_method_symbol
      return controller.render(nothing: true, status: 204) if [:delete, :patch, :put].include?(method)

      if method == :post
        path = "#{controller.openapi_path[:namespace]}#{response.resource}_path"
        controller.render(json: to_json_response, status: 201, location: controller.send(path, response.results))
        return
      end

      controller.render(json: to_json_response)
    end

    private

    def to_json_response
      if response.single?
        single_response
      else
        collection_response
      end
    end

    def fetch(opts)
      response.results.as_json(opts.merge(only: [],
                                          methods: response.fields))
    end

    def collection_response(opts = {})
      resp = {}
      resp[response.entity] = fetch(opts)
      success_response(resp)
    end

    def single_response(opts = {})
      success_response(fetch(opts))
    end

    def success_response(obj)
      obj.to_json
    end

    def error_response
      error_code = 400
      {
        status: error_code,
        json: {
          status: error_code,
          message: Rack::Utils::HTTP_STATUS_CODES[error_code],
          errors: response.errors
        }
      }
    end
  end
end
