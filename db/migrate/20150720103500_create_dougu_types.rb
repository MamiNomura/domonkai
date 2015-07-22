class CreateDouguTypes < ActiveRecord::Migration
  def change
    create_table(:dougu_types) do |t|
      t.integer :dougu_category_id, null: false
      t.string :name, null: false, limit: 50
      t.string :japanese_name, null: false, limit: 50
      t.string :description, limit: 1000
      t.timestamps
    end


    add_index :dougu_types, [:dougu_category_id]

  end
end
