class AddImagesToDougus < ActiveRecord::Migration

  def self.up
    add_attachment :dougus, :image_one
    add_attachment :dougus, :image_two
    add_attachment :dougus, :image_three

  end

  def down
    remove_attachment :dougus, :image_one
    remove_attachment :dougus, :image_two
    remove_attachment :dougus, :image_three
  end
end
