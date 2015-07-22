class CreateDouguCategories < ActiveRecord::Migration
  def change
    create_table(:dougu_categories) do |t|
      t.string :name, null: false, limit: 50
      t.string :japanese_name, null: false, limit: 50
      t.timestamps
    end
  end
end
