require "graphql"
require "promise"
require_relative "query"
require_relative "mutation"

Schema = GraphQL::Schema.define do
  lazy_resolve(Promise, :sync)

  query Cycad::GraphQL::Root::QueryType
  mutation Cycad::GraphQL::Root::MutationType
end
