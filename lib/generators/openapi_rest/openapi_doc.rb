OpenAPIRest::ApiDoc.configure do |c|
  c.document = YAML::load_file(File.join(Rails.root, 'config/api_docs.yml'))
end