class AddLanguageToMembers < ActiveRecord::Migration
  def change
    add_column :members, :language, :string
  end
end
