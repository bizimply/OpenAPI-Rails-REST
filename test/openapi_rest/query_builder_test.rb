require 'minitest/autorun'

describe OpenAPIRest::QueryBuilder do
  before do
    OpenAPIRest::ApiDoc.configure do |c|
      c.document = ::YAML::load_file('lib/generators/templates/api_docs.yml')
    end

    @api_model = OpenAPIRest::ApiModel.new(:product)
  end

  describe '' do
    before do
      params = ActionController::Parameters.new(openapi_path: { path: '/products', method: 'post' },
                                                product: { product_id: '2222' })
      @query_builder = OpenAPIRest::QueryBuilder.new(@api_model, params.merge!(operation: :create))
    end

    it 'check default params' do
      assert_empty(@query_builder.query)
      assert_nil(@query_builder.sort)
      assert_equal(@query_builder.limit, 10)
      assert_equal(@query_builder.offset, 0)
      assert_empty(@query_builder.fields)
      assert_equal(@query_builder.single_result?, true)
      assert_equal(@query_builder.single?, true)
      assert_equal(@query_builder.resource, 'product')
      assert_equal(@query_builder.entity, 'products')
      refute_nil(@query_builder.response)
    end
  end
end
