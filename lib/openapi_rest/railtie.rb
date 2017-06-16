module OpenAPIRest
  class Railtie < Rails::Railtie
    initializer "openapi_rest.action_controller" do
      ActiveSupport.on_load :action_controller do
        include OpenAPIRest::Extension::ClassMethods
      end
    end
  end
end
