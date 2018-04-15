module Cycad
  module GraphQL
    module Resolvers
      module Transaction
        class ByID
          def call(_obj, args, _ctx)
            Cycad.find_transaction(args[:id])
          end
        end

        class Filter
          def call(_obj, args, _ctx)
            Cycad.transactions(
              date: {
                from: args[:date_from],
                to: args[:date_to]
              },
              amount: {
                ge: args[:amount_ge],
                le: args[:amount_le]
              },
              category_ids: args[:category_ids],
              tags: args[:tags]
            )
          end
        end

        class Create
          def call(_obj, args, _ctx)
            date = Date.parse(args[:date])
            Cycad.create_transaction(
              date: date,
              amount: args[:amount],
              category_id: args[:category_id],
              note: args[:note],
              tags: args[:tags]
            ).value
          end
        end

        class Update
          def call(_obj, args, _ctx)
            attrs = {}
            attrs[:date] = Date.parse(args[:date]) if args[:date]
            attrs[:amount] = args[:amount] if args[:amount]
            attrs[:category_id] = args[:category_id] if args[:category_id]
            attrs[:note] = args[:note] if args[:note]
            attrs[:tags] = args[:tags] if args[:tags]
            Cycad.update_transaction(args[:id], attrs).value
          end
        end

        class Delete
          def call(_obj, args, _ctx)
            Cycad.delete_transaction(args[:id])
            "Transaction #{args[:id]} deleted."
          end
        end
      end
    end
  end
end
