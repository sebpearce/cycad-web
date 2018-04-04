require 'bundler'
Bundler.setup

require 'sinatra'
require './lib/cycad'
require './graphql/schema'

options '/graphql' do
  content_type :json

  response["Access-Control-Allow-Origin"] = '*'
  response["Access-Control-Allow-Headers"] = 'Content-Type, Authorization'
  response["Access-Control-Request-Method"] = '*'

  result_hash = Schema.execute('')
  result_hash.to_json
end

post '/graphql' do
  content_type :json

  response["Access-Control-Allow-Origin"] = '*'
  response["Access-Control-Allow-Headers"] = 'Content-Type, Authorization'
  response["Access-Control-Request-Method"] = '*'

  query = JSON.parse(request.body.read)['query']
  result_hash = Schema.execute(query)
  result_hash.to_json
end
