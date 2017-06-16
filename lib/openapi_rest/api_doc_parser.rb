module OpenAPIRest
  ###
  # Api doc parser based on OpenAPI 2.0 specs
  #
  class ApiDocParser
    attr_reader :method
    attr_reader :document

    def initialize(openapi_path)
      @document = OpenAPIRest::ApiDoc.document
      @route = openapi_path[:path]
      @method = openapi_path[:method]
      @method = 'patch' if @method == 'put'
    end

    def definitions
      @current_step = document.fetch('definitions', {})
      self
    end

    def parameters
      @current_step = document.fetch('parameters', {})
      self
    end

    def paths
      @current_step = document.fetch('paths', {})
      self
    end

    def find(key)
      @current_step = @current_step.fetch(key, {})
      self
    end

    def base_path
      document.fetch('basePath', {})
    end

    def find_path
      paths.find(@route.sub(base_path, '')).find(method)
    end

    def properties
      @current_step = @current_step.fetch('properties', {})
      self
    end

    def schema
      @current_step = @current_step.fetch('schema', {})

      if !@current_step['$ref'].nil?
        if @current_step['$ref'].include?('#/definitions/')
          str = @current_step['$ref'].gsub('#/definitions/', '')
          return definitions.find(str)
        end
      elsif !@current_step['items'].nil?
        if @current_step['items']['$ref'].include?('#/definitions/')
          str = @current_step['items']['$ref'].gsub('#/definitions/', '')
          return definitions.find(str)
        end
      end

      self
    end

    def find_parameters
      return if @current_step['parameters'].nil?

      params = {}
      ref_params = []
      @current_step['parameters'].each do |parameter|
        next if parameter['in'] == 'path'
        if parameter['in'] == 'query' || parameter['in'] == 'body'
          params[parameter['name']] = parameter['name']
          next
        end

        if !parameter['$ref'].nil? && parameter['$ref'].include?('#/parameters/')
          param = parameter['$ref'].gsub('#/parameters/', '')
          ref_params << document.fetch('parameters', {}).fetch(param, {})
        end
      end

      if ref_params.length > 0
        params.merge!(ref_params.compact.map { |param| param.fetch('schema', {}).fetch('properties', {}) }.first)
      end

      params
    end

    def responses
      @current_step = @current_step.fetch('responses', {})
      self
    end

    def keys
      @current_step.keys
    end

    def [](key)
      @current_step = @current_step.fetch(key, {})
      self
    end

    def to_s
      @current_step
    end
  end
end
