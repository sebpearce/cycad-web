require 'bundler'
Bundler.setup

require 'sinatra'
require './lib/cycad'

get '/transactions' do
  puts Cycad.transactions
  # Run Queries code in graphql-ruby.org getting started goes here
end
