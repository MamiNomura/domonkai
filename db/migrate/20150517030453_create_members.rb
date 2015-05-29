class CreateMembers < ActiveRecord::Migration
  def change
    create_table(:members) do |t|
      t.integer :domonkai_id, null: false, unique: true
      t.string :first_name, null: false, limit: 50
      t.string :last_name, null: false, limit: 50
      t.string :japanese_first_name, limit: 50
      t.string :japanese_last_name, limit: 50
      t.string :tea_name
      t.string :japanese_tea_name
      t.string :email
      t.string :sex, limit: 10 , default: "Female"
      t.string :address, limit: 255
      t.string :city, limit: 100
      t.string :state, limit: 20
      t.string :zip, limit: 15
      t.string :country, limit:20
      t.string :phone, limit: 15
      t.string :fax, limit: 15
      t.integer :sensei_member_id     #sensei's member id


      t.timestamps
    end

    add_index :members, [:domonkai_id]
    add_index :members, [:last_name, :first_name]
    add_index :members, [:japanese_last_name, :japanese_first_name]
    add_index :members, [:sensei_member_id]
  end
end
