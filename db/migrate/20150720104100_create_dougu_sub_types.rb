class CreateDouguSubTypes < ActiveRecord::Migration
  def change
    create_table(:dougu_sub_types) do |t|
      t.integer :dougu_type_id, null: false
      t.string :name, null: false, limit: 50
      t.string :japanese_name, null: false, limit: 50
      t.timestamps
    end

    add_index :dougu_sub_types, [:dougu_type_id]

  end
end
