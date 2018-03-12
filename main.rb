require 'sinatra'
require 'cycad'

get '/transactions' do
  puts Cycad.transactions
end
