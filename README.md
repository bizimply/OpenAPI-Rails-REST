# OpenAPIRest

This gem aims to provide an easier way to implement REST api endpoints using OpenAPI specs in a Rails project.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'openapi_rest'
```

And then execute:

    $ bundle install
    
Now, generate the initializer:

    $ rails g openapi_rest:install


## Usage

Place your OpenAPI spec yml file in `config/`, see example `generators/templates/api_docs.yml`. The file needs to be formatted in OpenAPI v2.0.  You can then use `OpenAPIRest::ApiModel` directly from a controller.  Example:

```ruby
class Product < ActiveRecord::Base
  
end
```

```ruby
module Api
  module V1
    class MyController < ActionController::Base
      def index 
        response = OpenAPIRest::ApiModel.new(:product).where(params)
        render_rest response
      end

      def show
        # The find method will expect a second parameter that ultimately will call find_by
        response = OpenAPIRest::ApiModel.new(:product).find(params, id: params[:id])
        if response.results?
          render_rest response
        end
      end

      def update
        # The find method will expect a second parameter that ultimately will call find_by
        response = OpenAPIRest::ApiModel.new(:product).find(params, id: params[:id])
        if response.results?
          response.update_resource

          render_rest response
        end
      end

      def create
        # For cases when our model needs to be inserted through another model.
        response = OpenAPIRest::ApiModel.new(:product).build(params, extra_param_ids: store.id)

        response.create_resource

        render_rest response
      end

      def destroy
        response = OpenAPIRest::ApiModel.new(:product).find(params, id: params[:id])
        if response.results?
          # When using cancancan gem, we can get the AR model by calling results.
          # authorize! :delete, response.results

          response.delete_resource

          render_rest response
        end
      end
    end
  end
end
```

`render_rest` is a custom method that takes a `QueryResponse` object to be rendered.

Last but not least, we need to tell to the Rails app which routes will be using the openapi parsing and if the routes have any namespace with the following syntax:

```ruby

scope module: :api, defaults: { format: 'json' }, openapi: true, namespace: 'api' do
  scope module: :v1 do
    resources :myresources, only: [:index, :show]
  end
end

```

### Adding a Custom Filter 

Create a wrapper object that inherits from `OpenAPIRest::ApiModel` if you need custom filter.  From the ApiModel you will have access to the `@model` class variable which is the original AR model.

Example:

```ruby
module Api
  class MyFilteredApiModel < OpenAPIRest::ApiModel
    def filter(params)
      @model = model.where('mymodelname.updated_at > ?', params[:date_param])
    end
  end
end
```

On the Controller side:

```ruby
module Api
  module V1
    class MyController < ActionController::Base
      def index
        # The where and find methods can contain a block which will return the wrapper so you can specify custom filters 
        response = Api::MyFilteredApiModel.new(:product).where(params) do |wrapper|
          wrapper.filter(params)
        end

        render_rest response
      end
    end
  end
end
```
      

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bizimply/OpenAPI-Rails-REST

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

