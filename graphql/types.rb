require 'graphql'

TransactionType = GraphQL::ObjectType.define do
  name 'Transaction'
  field :id, !types.ID
  field :amount, !types.Int
  field :date, !types.String
  field :note, types.String
  field :tags, types.String

  field :category, CategoryType do
    resolve -> (obj, args, ctx) { Cycad.find_category(obj.category_id) }
  end
end

CategoryType = GraphQL::ObjectType.define do
  name 'Category'
  field :id, !types.ID
  field :name, !types.String
  field :transactions, types[!TransactionType]
end
