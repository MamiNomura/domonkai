class Dougu < ActiveRecord::Base
  belongs_to :dougu_type, :class_name => "DouguType", :foreign_key => "dougu_type_id"

  validates :name,  presence: true
  validates :japanese_name,  presence: true


  # Validate the attached image is image/jpg, image/png, etc


  def pretty_name
    self.name + ' (' + self.japanese_name + ')'
  end

  def self.allowed_attributes
    [ 'dougu_type_id', 'name', 'japanese_name', 'description',
      'location', 'last_checked'
    ]
  end



end
