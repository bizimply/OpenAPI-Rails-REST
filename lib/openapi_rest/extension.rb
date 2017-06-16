module OpenAPIRest
  ###
  # Rest Extension
  #
  module Extension
    module ClassMethods #:nodoc:
      def self.included(clazz)
        clazz.send(:before_filter, :retrieve_openapi_path)
      end

      attr_reader :openapi_path

      def retrieve_openapi_path
        all_routes = Rails.application.routes.routes
        path = request.path
        nspace = ''
        all_routes.each do |r|
          next unless r.defaults.fetch(:openapi, false) && Regexp.new(r.verb).match(request.method)

          match = Regexp.new(r.path.source).match(request.path)
          next unless match

          nspace = r.defaults.fetch(:namespace, '')
          match.captures.each_with_index { |c, i| path.gsub!(c, "{#{r.path.names[i]}}") unless c.nil? }
        end
        @openapi_path = { method: request.method.downcase, path: path, namespace: "#{nspace}_" }
        params.merge!(openapi_path: @openapi_path)
      end

      def render_rest(response)
        OpenAPIRest::RestRenderer.new(controller: self, response: response).render
      end
    end
  end
end
