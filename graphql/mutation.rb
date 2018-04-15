require "graphql"
require_relative "types"
require_relative "resolvers/transaction"
require_relative "resolvers/category"

module Cycad
  module GraphQL
    class Root
      MutationType = ::GraphQL::ObjectType.define do
        name "Mutation"

        field :create_transaction, TransactionType do
          argument :date, !types.String
          argument :amount, !types.Int
          argument :category_id, !types.Int
          argument :note, types.String
          argument :tags, types.String

          resolve Cycad::GraphQL::Resolvers::Transaction::Create.new
        end

        field :update_transaction, TransactionType do
          argument :id, !types.Int
          argument :date, types.String
          argument :amount, types.Int
          argument :category_id, types.Int
          argument :note, types.String
          argument :tags, types.String

          resolve Cycad::GraphQL::Resolvers::Transaction::Update.new
        end

        field :delete_transaction, types.String do
          argument :id, !types.Int

          resolve Cycad::GraphQL::Resolvers::Transaction::Delete.new
        end

        field :create_category, CategoryType do
          argument :name, !types.String

          resolve Cycad::GraphQL::Resolvers::Category::Create.new
        end

        field :rename_category, CategoryType do
          argument :id, !types.Int
          argument :name, !types.String

          resolve Cycad::GraphQL::Resolvers::Category::Rename.new
        end

        field :delete_category, types.String do
          argument :id, !types.Int

          resolve Cycad::GraphQL::Resolvers::Category::Delete.new
        end
      end
    end
  end
end
