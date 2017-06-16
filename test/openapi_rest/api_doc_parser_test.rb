require 'minitest/autorun'
require 'openapi_rest/api_doc_parser'

describe OpenAPIRest::ApiDocParser do
  before do
    OpenAPIRest::ApiDoc.configure do |c|
      c.document = ::YAML::load_file('lib/generators/templates/api_docs.yml')
    end

    @api_doc_parser = OpenAPIRest::ApiDocParser.new(path: '/products',
                                                    method: 'get')
  end

  ['definitions', 'parameters', 'paths'].each do |method_name|
    it "##{method_name}" do
      name = OpenAPIRest::ApiDoc.document.fetch(method_name, {})
      refute_nil(@api_doc_parser.send(method_name))
      assert_equal(@api_doc_parser.send(method_name).to_s, name)
    end
  end

  it '#find(key)' do
    definitions = OpenAPIRest::ApiDoc.document.fetch('definitions', {})
    assert_equal(@api_doc_parser.definitions.find('Product').to_s, definitions.fetch('Product'))
  end

  it '#base_path' do
    assert_equal(@api_doc_parser.base_path, '/v1')
  end

  it '#find_path' do
    paths = OpenAPIRest::ApiDoc.document.fetch('paths', {}).fetch('/products').fetch('get')
    assert_equal(@api_doc_parser.find_path.to_s, paths)
  end

  it '#properties' do
    properties = OpenAPIRest::ApiDoc.document.fetch('definitions', {}).fetch('Product').fetch('properties')
    assert_equal(@api_doc_parser.definitions.find('Product').properties.to_s, properties)
  end

  describe '#schema' do
    it 'with items' do
      product = OpenAPIRest::ApiDoc.document.fetch('definitions', {}).fetch('Product')
      assert_equal(@api_doc_parser.find_path.responses.find(200).schema.to_s, product)
    end

    it 'with ref' do
      error = OpenAPIRest::ApiDoc.document.fetch('definitions', {}).fetch('Error')
      assert_equal(@api_doc_parser.find_path.responses.find('default').schema.to_s, error)
    end
  end

  it '#find_parameters' do
    assert_equal(@api_doc_parser.find_path.find_parameters, { 'latitude' => 'latitude', 'longitude' => 'longitude' })
  end

  it '#responses' do
    responses = OpenAPIRest::ApiDoc.document.fetch('paths', {}).fetch('/products').fetch('get').fetch('responses')
    assert_equal(@api_doc_parser.find_path.responses.to_s, responses)
  end

  it '#responses' do
    keys = OpenAPIRest::ApiDoc.document.fetch('paths', {}).fetch('/products').fetch('get').fetch('responses').keys
    assert_equal(@api_doc_parser.find_path.responses.keys, keys)
  end

  it '#[](key)' do
    products = OpenAPIRest::ApiDoc.document.fetch('paths', {}).fetch('/products')
    assert_equal(@api_doc_parser.paths['/products'].to_s, products)
  end
end
