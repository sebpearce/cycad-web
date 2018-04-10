require 'graphql'
require_relative 'types'
require_relative '../lib/cycad'

QueryType = GraphQL::ObjectType.define do
  name 'Query'
  description 'the query root'

  field :transaction do
    type TransactionType
    argument :id, !types.ID
    description 'Find a transaction by ID'
    resolve -> (obj, args, ctx) { Cycad.find_transaction(args[:id]) }
  end

  field :category do
    type CategoryType
    argument :id, !types.ID
    description 'Find a category by ID'
    resolve -> (obj, args, ctx) { Cycad.find_category(args[:id]) }
  end

  field :transactions, types[TransactionType] do
    resolve -> (obj, args, ctx) {
      Cycad.transactions
    }
  end
end

Schema = GraphQL::Schema.define do
  query QueryType
end
