class Member < ActiveRecord::Base
  belongs_to :shachu, :class_name => "Member", :foreign_key => "sensei_member_id"
  has_many :students, :class_name => "Member", :foreign_key => "sensei_member_id"
  belongs_to :shikaku_kubun


  validates :phone, numericality: { only_integer: true }
  validates :fax, numericality: { only_integer: true }
  validates :domonkai_id,  presence: true, uniqueness: true
  validates :first_name,  presence: true
  validates :last_name,  presence: true
  validates :japanese_first_name,  presence: true
  validates :japanese_last_name,  presence: true



  def self.import(file)

    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      member = find_by( domonkai_id: row["domonkai_id"]) || new
      member.attributes = row.to_hash.slice(*accessible_attributes)
      member.save!
    end
  end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
      when ".csv" then Csv.new(file.path, nil, :ignore)
      when ".xls" then Excel.new(file.path, nil, :ignore)
      when ".xlsx" then Excelx.new(file.path, nil, :ignore)
      else raise "Unknown file type: #{file.original_filename}"
    end
  end


end