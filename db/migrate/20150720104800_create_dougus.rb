class CreateDougus < ActiveRecord::Migration
  def change
    create_table(:dougus) do |t|
      t.integer :dougu_category_id, null: false
      t.integer :dougu_type_id, null: false
      t.integer :dougu_sub_type_id, null: true
      t.string :name, null: false, limit: 100
      t.string :japanese_name, null: false, limit: 100
      t.string :description, limit:2000
      t.string :location, limit:100
      t.datetime :last_checked
      t.timestamps
    end

    add_index :dougus, [:dougu_category_id]
    add_index :dougus, [:dougu_type_id]
    add_index :dougus, [:dougu_sub_type_id]

  end
end
