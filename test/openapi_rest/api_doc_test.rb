require 'minitest/autorun'
require 'openapi_rest/api_doc'
require 'yaml'

describe OpenAPIRest::ApiDoc do
  before do
    OpenAPIRest::ApiDoc.configure do |c|
      c.document = ::YAML::load_file('lib/generators/templates/api_docs.yml')
    end
  end

  it '#document' do
    refute_nil(OpenAPIRest::ApiDoc.document)
  end
end
