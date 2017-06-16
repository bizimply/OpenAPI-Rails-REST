require 'minitest/autorun'

describe OpenAPIRest::QueryResponse do
  before do
    OpenAPIRest::ApiDoc.configure do |c|
      c.document = ::YAML::load_file('lib/generators/templates/api_docs.yml')
    end

    @api_model = OpenAPIRest::ApiModel.new(:product)
  end

  describe '#create_resource' do
    describe 'without errors' do
      before do
        params = ActionController::Parameters.new(openapi_path: { path: '/products', method: 'post' },
                                                  product: { product_id: '2222' })
        query_builder = OpenAPIRest::QueryBuilder.new(@api_model, params.merge!(operation: :create))
        @response = query_builder.response
        @response.create_resource
      end

      it 'check default params' do
        product_created = Product.find_by(product_id: '2222')

        assert_empty(@response.errors)
        assert_equal(@response.errors?, false)
        refute_nil(@response)
        assert_equal(@response.results, product_created)

        refute_nil(product_created)
      end
    end

    describe 'with errors' do
      before do
        params = ActionController::Parameters.new(openapi_path: { path: '/products', method: 'post' }, product: {})
        query_builder = OpenAPIRest::QueryBuilder.new(@api_model, params.merge!(operation: :create))
        @response = query_builder.response
        @response.create_resource
      end

      it 'check default params' do
        refute_nil(@response)
        refute_empty(@response.errors)
        assert_equal(@response.errors?, true)
      end
    end
  end

  describe '#update_resource' do
    describe 'without errors' do
      before do
        params = ActionController::Parameters.new(openapi_path: { path: '/products/{id}', method: 'patch' },
                                                  product: { name: 'test product' })
        query_builder = OpenAPIRest::QueryBuilder.new(@api_model, params.merge!(operation: :squery,
                                                                                 query: { product_id: '2222' }))
        @response = query_builder.response
        @response.update_resource
      end

      it 'check default params' do
        product_updated = Product.find_by(product_id: '2222')

        assert_empty(@response.errors)
        assert_equal(@response.errors?, false)
        refute_nil(@response)
        assert_equal(@response.results, product_updated)

        refute_nil(product_updated)
        assert_equal(product_updated.name, 'test product')
      end
    end

    describe 'with wrong params' do
      before do
        params = ActionController::Parameters.new(openapi_path: { path: '/products/{id}', method: 'patch' },
                                                  product: { capacity: 'test' })
        query_builder = OpenAPIRest::QueryBuilder.new(@api_model, params.merge!(operation: :squery,
                                                                                query: { product_id: '2222' }))
        @response = query_builder.response
        @response.update_resource
      end

      it 'check default params' do
        product_updated = Product.find_by(product_id: '2222')

        refute_nil(@response)
        assert_equal(@response.results, product_updated)

        assert_nil(product_updated.capacity)
      end
    end
  end

  describe '#delete_resource' do
    describe 'without errors' do
      before do
        @product_deleted = Product.find_by(product_id: '5555')

        params = ActionController::Parameters.new(openapi_path: { path: '/products/{id}', method: 'delete' })
        query_builder = OpenAPIRest::QueryBuilder.new(@api_model, params.merge!(operation: :squery,
                                                                                 query: { product_id: '5555' }))
        @response = query_builder.response
        @response.delete_resource
      end

      it 'check default params' do
        assert_empty(@response.errors)
        assert_equal(@response.errors?, false)
        assert_equal(@response.results?, true)
        assert_equal(@response.results, @product_deleted)
      end
    end

    describe 'non existing' do
      before do
        params = ActionController::Parameters.new(openapi_path: { path: '/products/{id}', method: 'delete' })
        query_builder = OpenAPIRest::QueryBuilder.new(@api_model, params.merge!(operation: :squery,
                                                                                 query: { product_id: '4444' }))
        @response = query_builder.response
        @response.delete_resource
      end

      it 'check default params' do
        assert_equal(@response.results?, false)
      end
    end
  end
end