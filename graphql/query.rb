require "graphql"
require_relative "types"
require_relative "resolvers/transaction"
require_relative "resolvers/category"

module Cycad
  module GraphQL
    class Root
      QueryType = ::GraphQL::ObjectType.define do
        name "Query"
        description "the query root"

        field :transaction, TransactionType do
          argument :id, !types.Int

          resolve Cycad::GraphQL::Resolvers::Transaction::ByID.new
        end

        field :category, CategoryType do
          argument :id, !types.Int

          resolve Cycad::GraphQL::Resolvers::Category::ByID.new
        end

        field :transactions, types[TransactionType] do
          argument :date_from, types.String
          argument :date_to, types.String
          argument :amount_le, types.Int
          argument :amount_ge, types.Int
          argument :category_ids, types[types.Int]
          argument :tags, types.String

          resolve Cycad::GraphQL::Resolvers::Transaction::Filter.new
        end

        field :categories, types[CategoryType] do
          resolve Cycad::GraphQL::Resolvers::Category::All.new
        end
      end
    end
  end
end
