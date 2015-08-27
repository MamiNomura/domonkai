class ResetDouguTables < ActiveRecord::Migration

  def change
    drop_table(:dougus)
    drop_table(:dougu_sub_types)
    drop_table(:dougu_types)
    drop_table(:dougu_categories)



    create_table(:dougu_types) do |t|
      t.string :name, null: false, limit: 50
      t.string :japanese_name, null: false, limit: 50
      t.string :description, limit: 1000
      t.timestamps
    end

    create_table(:dougu_sub_types) do |t|
      t.integer :dougu_type_id, null: false
      t.string :name, null: false, limit: 50
      t.string :japanese_name, null: false, limit: 50
      t.timestamps
    end

    add_index :dougu_sub_types, [:dougu_type_id]

    create_table(:dougus) do |t|
      t.integer :dougu_type_id, null: false
      t.integer :dougu_sub_type_id, null: true
      t.string :name, null: false, limit: 100
      t.string :japanese_name, null: false, limit: 100
      t.string :description, limit:2000
      t.string :location, limit:100
      t.string :image_link_one, limit: 1000
      t.string :image_link_two, limit: 1000
      t.string :image_link_three, limit: 1000
      t.datetime :last_checked
      t.timestamps
    end


    add_index :dougus, [:dougu_type_id]
    add_index :dougus, [:dougu_sub_type_id]

  end

end
