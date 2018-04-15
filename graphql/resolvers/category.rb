module Cycad
  module GraphQL
    module Resolvers
      module Category
        class ByID
          def call(_obj, args, _ctx)
            Cycad.find_category(args[:id])
          end
        end

        class All
          def call(_obj, _args, _ctx)
            Cycad.categories
          end
        end

        class Create
          def call(_obj, args, _ctx)
            Cycad.create_category(args[:name]).value
          end
        end

        class Rename
          def call(_obj, args, _ctx)
            Cycad.rename_category(args[:id], args[:name]).value
          end
        end

        class Delete
          def call(_obj, args, _ctx)
            Cycad.delete_category(args[:id])
            "Category #{args[:id]} deleted."
          end
        end
      end
    end
  end
end
