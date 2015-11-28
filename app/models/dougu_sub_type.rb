class DouguSubType < ActiveRecord::Base
  belongs_to :dougu_type, :class_name => "DouguType", :foreign_key => "dougu_type_id"
  #validates :name,  presence: true
  #validates :japanese_name,  presence: true

  def pretty_name
    unless self.name.nil?
      pretty_name = self.name + ' (' + self.japanese_name + ')'
    else
      pretty_name = ""
    end
    return pretty_name
  end


  def self.allowed_attributes
    [ 'name', 'japanese_name']
  end
end
