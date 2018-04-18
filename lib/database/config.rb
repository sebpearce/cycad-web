require "date"
require "rom"
require "rom-sql"
require "rom-repository"
require "securerandom"
require_relative "../cycad/category/category_mapper"
require_relative "../cycad/transaction/transaction_mapper"
require_relative "category_relation"
require_relative "transaction_relation"

module Database
  class Config
    Rom = ROM.container(:sql, ENV["DATABASE_URL"]) do |conf|
      conf.register_relation(Database::Relations::Categories)
      conf.register_relation(Database::Relations::Transactions)
      conf.register_mapper(Cycad::CategoryMapper)
      conf.register_mapper(Cycad::TransactionMapper)
      conf.gateways[:default].use_logger(Logger.new($stdout))
    end
  end
end

