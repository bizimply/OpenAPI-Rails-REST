module OpenapiRest
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root(File.expand_path(File.dirname(__FILE__)))
      def copy_initializer
        copy_file 'openapi_doc.rb', 'config/initializers/openapi_doc.rb'
        copy_file '../templates/api_docs.yml', 'config/api_docs.yml'
      end
    end
  end
end