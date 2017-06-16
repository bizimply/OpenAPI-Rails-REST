require 'minitest/autorun'
require 'openapi_rest/api_validator'
require 'openapi_rest/validators/format'
require 'openapi_rest/validators/pattern'

describe OpenAPIRest::ApiValidator do
  describe '#evaluate' do
    describe 'with integers' do
      before do
        @params = {}
        @params['format'] = 'int64'
      end

      it 'be valid' do
        OpenAPIRest::ApiValidator.new(@params).evaluate([:id], { id: 123 })
      end

      it 'not be valid' do
        OpenAPIRest::ApiValidator.new(@params).evaluate([:id], { id: 'test' })
      end
    end
  end
end