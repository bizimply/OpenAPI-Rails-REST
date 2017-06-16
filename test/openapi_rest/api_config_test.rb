require 'minitest/autorun'
require 'openapi_rest/api_config'

describe OpenAPIRest::ApiConfig do
  it 'initialize document correctly' do
    api_config = OpenAPIRest::ApiConfig.new(document: 'mylocaldoc')
    assert_equal(api_config.document, 'mylocaldoc')
  end
end
