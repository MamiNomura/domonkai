class AddShikakuKubunToMembers < ActiveRecord::Migration

  def up
    change_table :members do |t|
      t.integer :shikaku_kubun_id
    end
  end

  def down
    remove_column :members, :shikaku_kubun_id
  end
end
