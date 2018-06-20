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

    it 'adds a new transaction for a particular category' do
      category = Cycad.create_category('chairs').value
      mutation = """
          mutation foo {
            create_transaction(date: \"2018-04-22\", amount: -570, category_id: #{category.id}) {
              id
              date
              amount
              category_id
            }
          }
        """
      result = Schema.execute(mutation)
      p result['data']['create_transaction']['category_id']
      expect(result['data']['create_transaction']['category_id']).to eq(category.id)
    end

    fit 'filters transactions for a given amount range' do
      category = Cycad.create_category('peanuts').value
      transaction_one = Cycad.create_transaction(
        date: Date.new(2018,6,11),
        amount: 400,
        category_id: category.id
      ).value
      transaction_two = Cycad.create_transaction(
        date: Date.new(2018,7,20),
        amount: 48,
        category_id: category.id
      ).value
      transaction_three = Cycad.create_transaction(
        date: Date.new(2018,8,20),
        amount: 250,
        category_id: category.id
      ).value

      query = """
        query foo {
          transactions(date_from: \"2018-06-01\", date_to: \"2018-06-30\") {
            id
            amount
          }
        }
      """

      results = Schema.execute(query)
      expect(results['data']['transactions'].first['id']).to eq(transaction_one.id)
    end
  end
end
