class AddYakuinCheckToMembers < ActiveRecord::Migration
  def up
    add_column :members, :yakuin, :boolean, default: false
  end

  def down
    remove_column :members, :yakuin
  end
end
