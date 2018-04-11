require 'graphql'
require_relative 'types'
require_relative '../lib/cycad'

QueryType = GraphQL::ObjectType.define do
  name 'Query'
  description 'the query root'

  field :transaction, TransactionType do
    argument :id, !types.ID
    description 'Find a transaction by ID'
    resolve -> (obj, args, ctx) { Cycad.find_transaction(args[:id]) }
  end

  field :category, CategoryType do
    argument :id, !types.ID
    description 'Find a category by ID'
    resolve -> (obj, args, ctx) { Cycad.find_category(args[:id]) }
  end

  field :transactions, types[TransactionType] do
    argument :date_from, types.String
    argument :date_to, types.String
    argument :amount_le, types.Int
    argument :amount_ge, types.Int
    argument :category_ids, types[types.Int]
    argument :tags, types.String

    resolve -> (obj, args, ctx) {
      Cycad.transactions(
        date: {
          from: args[:date_from],
          to: args[:date_to]
        },
        amount: {
          ge: args[:amount_ge],
          le: args[:amount_le]
        },
        category_ids: args[:category_ids],
        tags: args[:tags]
      )
    }
  end
end

Mutations = GraphQL::ObjectType.define do
  name "Mutations"

  field :create_category, CategoryType do
    argument :name, !types.String

    resolve -> (obj, args, ctx) {
      Cycad.create_category(args[:name]).value
    }
  end
end

Schema = GraphQL::Schema.define do
  query QueryType
  mutation Mutations
end
