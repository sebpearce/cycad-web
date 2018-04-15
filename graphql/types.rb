require "graphql"

TransactionType = GraphQL::ObjectType.define do
  name "Transaction"
  field :id, !types.Int
  field :amount, !types.Int
  field :date, !types.String
  field :note, types.String
  field :tags, types.String
  field :category_id, types.Int

  field :category, CategoryType do
    resolve -> (obj, args, ctx) { Cycad.find_category(obj.category_id) }
  end
end

CategoryType = GraphQL::ObjectType.define do
  name "Category"
  field :id, !types.Int
  field :name, !types.String
  field :transactions, types[!TransactionType]
end
