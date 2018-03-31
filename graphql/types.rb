require 'graphql'

TransactionType = GraphQL::ObjectType.define do
  name 'Transaction'
  field :id, !types.ID
  field :amount, !types.Int
  field :category, types[!CategoryType]
  field :date, !types.String
  field :note, types.String
  field :tags, types.String
end

CategoryType = GraphQL::ObjectType.define do
  name 'Category'
  field :id, !types.ID
  field :name, !types.String
  field :transactions, types[!TransactionType]
end
