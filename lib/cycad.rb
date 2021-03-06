require "dotenv/load"
require_relative "cycad/repo"
require_relative "in_memory_db/category_repo"
require_relative "in_memory_db/transaction_repo"
require_relative "database/config"
require_relative "database/category_repo"
require_relative "database/transaction_repo"
require_relative "cycad/transaction/use_cases/create"
require_relative "cycad/transaction/use_cases/update"
require_relative "cycad/transaction/use_cases/delete"
require_relative "cycad/category"
require_relative "cycad/category/category_mapper"
require_relative "cycad/category/use_cases/create"
require_relative "cycad/category/use_cases/rename"
require_relative "cycad/category/use_cases/delete"
require_relative "cycad/category/category_validator"
require_relative "cycad/transaction"
require_relative "cycad/transaction/transaction_validator"
require_relative "cycad/transaction/filters/date_filter"
require_relative "cycad/transaction/filters/amount_filter"
require_relative "cycad/transaction/filters/category_filter"
require_relative "cycad/transaction/use_cases/update"
require_relative "cycad/transaction/use_cases/create"

Cycad::Repository.register(:category, Database::CategoryRepo.new(Database::Config::Rom))
Cycad::Repository.register(:transaction, Database::TransactionRepo.new(Database::Config::Rom))

module Cycad
  class << self
    def find_transaction(id)
      Cycad::Repository.for(:transaction).by_id(id)
    end

    def transactions(**args)
      Cycad::Repository.for(:transaction).filter(**args)
    end

    def create_transaction(attrs = {})
      # TODO extract this to a type checker module
      raise "Please give me a hash." unless attrs.is_a? Hash
      Cycad::Transaction::UseCases::Create.new.call(attrs)
    end

    def update_transaction(id, attrs = {})
      Cycad::Transaction::UseCases::Update.new.call(id: id, attrs: attrs)
    end

    def delete_transaction(id)
      Cycad::Transaction::UseCases::Delete.new.delete(id: id)
    end

    def categories
      Cycad::Repository.for(:category).all
    end

    def find_category(id)
      Cycad::Repository.for(:category).by_id(id)
    end

    def find_categories(ids)
      Cycad::Repository.for(:category).by_ids(ids)
    end

    def create_category(name)
      Cycad::Category::UseCases::Create.new.call(name: name)
    end

    def rename_category(id, new_name)
      Cycad::Category::UseCases::Rename.new.call(id: id, name: new_name)
    end

    def delete_category(id)
      Cycad::Category::UseCases::Delete.new.delete(id: id)
    end
  end
end
