require "graphql"
require_relative "query"
require_relative "mutation"

Schema = GraphQL::Schema.define do
  query Cycad::GraphQL::Root::QueryType
  mutation Cycad::GraphQL::Root::MutationType
end
