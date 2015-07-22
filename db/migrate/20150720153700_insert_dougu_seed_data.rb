class InsertDouguSeedData < ActiveRecord::Migration
  def change
    DouguCategory.create :name => "Chaki", :japanese_name => "茶器"
  end
end
