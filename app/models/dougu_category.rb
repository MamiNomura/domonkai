class DouguCategory < ActiveRecord::Base
  validates :name,  presence: true
  validates :japanese_name,  presence: true

  def pretty_name
    self.name + ' (' + self.japanese_name + ')'
  end
end
