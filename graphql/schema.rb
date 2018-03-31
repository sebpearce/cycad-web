require 'graphql'
require_relative 'types'
require_relative '../lib/cycad'

QueryType = GraphQL::ObjectType.define do
  name 'Query'

  field :transaction do
    type TransactionType
    argument :id, !types.ID
    description 'Find a transaction by ID'
    resolve ->(obj, args, ctx) { Cycad.find_transaction(args[:id]) }
  end
end

Schema = GraphQL::Schema.define do
  query QueryType
end
