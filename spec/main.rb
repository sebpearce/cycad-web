require 'spec_helper'
require_relative '../graphql/schema'

RSpec.describe 'GraphQL endpoint', db: true do
  context 'with an empty db' do
    it 'adds a new category' do
      mutation = """
          mutation foo {
            create_category(name: \"test_category\") {
              name
            }
          }
        """
      result_hash = Schema.execute(mutation)
      expect(result_hash["data"]["create_category"]["name"]).to eq("test_category")
    end

    context 'with existing categories' do
      before do
        mutation = """
          mutation foo {
            create_category(name: \"dog food\") {
              name
            }
          }
        """
        mutation_two = """
          mutation foo {
            create_category(name: \"cat food\") {
              name
            }
          }
        """
      Schema.execute(mutation)
      Schema.execute(mutation_two)
      end

      it 'gets all categories' do
        query = """
          query foo {
            categories {
              id
              name
            }
          }
        """
        result_hash = Schema.execute(query)
        expect(result_hash["data"]["categories"].map {|x| x["name"]}).to include("dog food", "cat food")
      end
    end

    # TODO: I can't pass in the category_id  here, because I don't know what it
    # was when I added the category above.  Do I need to parse the category
    # mutation output?!
    # it 'adds a new transaction' do
    #   mutation = """
    #       mutation foo {
    #         create_transaction(date: \"2018-04-22\", amount: -570, category_id: 2) {
    #           id
    #           date
    #           amount
    #         }
    #       }
    #     """
    #   result = Schema.execute(mutation).to_json
    #   expect(result).to eq(%Q['result goes here'])
    # end
  end
end
