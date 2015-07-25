class AddRolesToAdmins < ActiveRecord::Migration

  def change
    add_column :admin_users, :role, :string , limit: 30
  end

end
