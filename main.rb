require 'bundler'
Bundler.setup

require 'dataloader'
require 'sinatra'
require './lib/cycad'
require './graphql/schema'

options '/graphql' do
  content_type :json

  response["Access-Control-Allow-Origin"] = '*'
  response["Access-Control-Allow-Headers"] = 'Content-Type, Authorization'
  response["Access-Control-Request-Method"] = '*'
  execute_schema('')
end

post '/graphql' do
  content_type :json

  response["Access-Control-Allow-Origin"] = '*'
  response["Access-Control-Allow-Headers"] = 'Content-Type, Authorization'
  response["Access-Control-Request-Method"] = '*'
  query = JSON.parse(request.body.read)['query']
  execute_schema(query)
end

def execute_schema(query)
  result_hash = Schema.execute(
    query,
    context: {
      category_loader: category_loader
    }
  )
  result_hash.to_json
end

def category_loader
  Dataloader.new do |ids|
    Cycad.find_categories(ids)
  end
end
