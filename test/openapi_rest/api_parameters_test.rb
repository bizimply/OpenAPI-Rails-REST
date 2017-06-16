require 'minitest/autorun'
require 'spec_helper'
require 'action_controller'
require 'openapi_rest/api_parameters'

describe OpenAPIRest::ApiParameters do
  before do
    OpenAPIRest::ApiDoc.configure do |c|
      c.document = ::YAML::load_file('lib/generators/templates/api_docs.yml')
    end

    params = ActionController::Parameters.new(openapi_path: { path: '/products', method: 'post' },
                                              product: { product_id: '0000' })

    model = OpenAPIRest::ApiModel.new(:product)

    @api_parameters = OpenAPIRest::ApiParameters.new(api_model: model,
                                                     params: params,
                                                     openapi_path: params[:openapi_path])
  end

  it '#initialize' do
    refute_nil(@api_parameters)
  end

  describe '#valid?' do
    it 'with errors' do
      model = OpenAPIRest::ApiModel.new(:product)
      params = ActionController::Parameters.new(product_id: '0000')

      api_parameters_with_error = OpenAPIRest::ApiParameters.new(api_model: model,
                                                                 params: params,
                                                                 openapi_path: { path: '/products', method: 'post' })

      assert_equal(api_parameters_with_error.valid?, false)
      refute_empty(api_parameters_with_error.validation_errors)
    end

    it 'without errors' do
      assert_equal(@api_parameters.valid?, true)
      assert_empty(@api_parameters.validation_errors)
    end
  end

  it '#response_permitted_params' do
    params = ActionController::Parameters.new(openapi_path: { path: '/products', method: 'get' })

    model = OpenAPIRest::ApiModel.new(:product)

    api_parameters = OpenAPIRest::ApiParameters.new(api_model: model,
                                                    params: params,
                                                    openapi_path: params[:openapi_path])

    assert_equal(api_parameters.response_permitted_params, [:product_id, :description, :name, :capacity,
                                                            :image])
  end
end
