require 'bundler'
Bundler.setup

require 'sinatra'
require './lib/cycad'
require './graphql/schema'

get '/transactions' do
  # Run Queries code in graphql-ruby.org getting started goes here
  query_string = "
  {
    transaction(id: 4) {
      id
      amount
      date
    }
  }
  "
  result_hash = Schema.execute(query_string)
  result_hash.to_h.to_s
end
