class AddUpdatedCheckToMembers < ActiveRecord::Migration
  def up
    add_column :members, :record_updated, :boolean, default: false
  end

  def down
    remove_column :members, :record_updated
  end
end
