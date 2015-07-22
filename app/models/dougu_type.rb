class DouguType < ActiveRecord::Base
  belongs_to :dougu_category, :class_name => "DouguCategory", :foreign_key => "dougu_category_id"
  validates :name,  presence: true
  validates :japanese_name,  presence: true


  def pretty_name
    self.name + ' (' + self.japanese_name + ')'
  end
end
