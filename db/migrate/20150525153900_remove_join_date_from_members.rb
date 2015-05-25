class RemoveJoinDateFromMembers < ActiveRecord::Migration
  def change
    remove_column :members, :join_date, :datetime
  end
end