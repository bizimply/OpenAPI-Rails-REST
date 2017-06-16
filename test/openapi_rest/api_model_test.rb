require 'minitest/autorun'
require 'spec_helper'
require 'action_controller'
require 'openapi_rest/api_model'
require 'openapi_rest/api_parameters'
require 'openapi_rest/api_validator'
require 'openapi_rest/query_builder'
require 'openapi_rest/query_response'
require 'openapi_rest/operations/filter'
require 'openapi_rest/operations/paginate'
require 'openapi_rest/operations/sort'

describe OpenAPIRest::ApiModel do
  before do
    OpenAPIRest::ApiDoc.configure do |c|
      c.document = ::YAML::load_file('lib/generators/templates/api_docs.yml')
    end

    @api_model = OpenAPIRest::ApiModel.new(:product)
  end

  it '#model' do
    assert_equal(@api_model.model, Product)
  end

  it '#build' do
    params = ActionController::Parameters.new(openapi_path: { path: '/products', method: 'post' },
                                              product: { product_id: '1234' })
    api_product = @api_model.build(params)

    refute_nil(api_product)
    assert_kind_of(OpenAPIRest::QueryResponse, api_product)
  end

  it '#find' do
    params = ActionController::Parameters.new(openapi_path: { path: '/products/0000', method: 'get' },
                                              product: { product_id: '0000' })
    response = @api_model.find(params, product_id: '0000')

    assert_equal(response.results, Product.find_by(product_id: '0000'))
  end

  it '#where' do
    params = ActionController::Parameters.new(openapi_path: { path: '/products', method: 'get' })
    response = @api_model.where(params)

    assert_equal(response.results, Product.all.to_a)
  end
end
