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

  field :categories, types[CategoryType] do
    resolve -> (obj, args, ctx) {
      Cycad.categories
    }
  end
end

Mutations = GraphQL::ObjectType.define do
  name "Mutations"

  field :create_transaction, TransactionType do
    argument :date, !types.String
    argument :amount, !types.Int
    argument :category_id, !types.Int
    argument :note, types.String
    argument :tags, types.String

    resolve -> (obj, args, ctx) {
      date = Date.parse(args[:date])
      Cycad.create_transaction(
        date: date,
        amount: args[:amount],
        category_id: args[:category_id],
        note: args[:note],
        tags: args[:tags]
      ).value
    }
  end

  field :create_category, CategoryType do
    argument :name, !types.String

    resolve -> (obj, args, ctx) {
      Cycad.create_category(args[:name]).value
    }
  end

  field :rename_category, CategoryType do
    argument :id, !types.Int
    argument :name, !types.String

    resolve -> (obj, args, ctx) {
      Cycad.rename_category(args[:id], args[:name]).value
    }
  end

  # TODO trying to delete a category that a transaction is referencing triggers a foreign key constraint error
  field :delete_category, types.String do
    argument :id, !types.Int

    resolve -> (obj, args, ctx) {
      Cycad.delete_category(args[:id])
      "Row #{args[:id]} deleted!"
    }
  end
end

Schema = GraphQL::Schema.define do
  query QueryType
  mutation Mutations
end
