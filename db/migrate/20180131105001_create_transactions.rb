ROM::SQL.migration do
  change do
    create_table :transactions do
      primary_key :id
      column :amount, Integer, null: false
      column :date, Date, null: false
      column :category_id, Integer
      column :note, String
      column :tags, String
    end
  end
end
