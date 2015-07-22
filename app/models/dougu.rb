class Dougu < ActiveRecord::Base
  belongs_to :dougu_category, :class_name => "DouguCategory", :foreign_key => "dougu_category_id"
  belongs_to :dougu_type, :class_name => "DouguType", :foreign_key => "dougu_type_id"
  belongs_to :dougu_sub_type, :class_name => "DouguSubType", :foreign_key => "dougu_sub_type_id"

  validates :name,  presence: true
  validates :japanese_name,  presence: true

  # This method associates the attribute ":image_one" with a file attachment
  has_attached_file :image_one, styles: {
                                  thumb: '100x100>',
                                  medium: '200x200>'
                              }
  has_attached_file :image_two, styles: {
                                  thumb: '100x100>',
                                  medium: '200x200>'
                              }
  has_attached_file :image_three, styles: {
                                  thumb: '100x100>',
                                  medium: '200x200>'
                              }

  # Validate the attached image is image/jpg, image/png, etc
  validates_attachment_content_type :image_one, :content_type => /\Aimage\/.*\Z/

  def category_name
    unless self.dougu_type.nil?
      self.dougu_type.dougu_category.name
    end
  end

  def pretty_name
    self.name + ' (' + self.japanese_name + ')'
  end

  def self.allowed_attributes
    [ 'dougu_category_id','dougu_type_id', 'dougu_sub_type_id', 'name', 'japanese_name', 'description',
      'location', 'last_checked'
    ]
  end



end