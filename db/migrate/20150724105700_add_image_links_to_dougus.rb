class AddImageLinksToDougus < ActiveRecord::Migration

  def change
    add_column :dougus, :image_link_one, :string , limit: 1000
    add_column :dougus, :image_link_two, :string , limit: 1000
    add_column :dougus, :image_link_three, :string , limit: 1000
  end

end
