require_relative '../category'

module Cycad
  class CategoryMapper < ROM::Mapper
    register_as :category
    relation :categories

    model Cycad::Category

    attribute :id
    attribute :name
  end
end
