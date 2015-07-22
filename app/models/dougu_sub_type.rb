class DouguSubType < ActiveRecord::Base
  belongs_to :dougu_type, :class_name => "DouguType", :foreign_key => "dougu_type_id"
  validates :name,  presence: true
  validates :japanese_name,  presence: true

  def pretty_name
    self.name + ' (' + self.japanese_name + ')'
  end

end
