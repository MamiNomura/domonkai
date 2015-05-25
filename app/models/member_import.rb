class MemberImport
  # switch to ActiveModel::Model in Rails 4
  extend ActiveModel::Model
  #extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :file

  def initialize(attributes = {})

    attributes.each { |name, value| send("#{name}=", value) }
  end

  def persisted?
    false
  end

  def save
    if imported_members.map(&:valid?).all?
      imported_members.each(&:save!)
      true
    else
      imported_members.each_with_index do |member, index|
        member.errors.full_messages.each do |message|
          errors.add :base, "Row #{index+2}: #{message}"
        end
      end
      false
    end
  end

  def imported_members
    @imported_members ||= load_imported_members
  end

  def load_imported_members
    spreadsheet = open_spreadsheet
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).map do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      member = Member.find_by(domonkai_id: row["id"]) || Member.new
      member.attributes = row.to_hash.slice(*Member.allowed_attributes)
      #member.attributes = row.to_hash.slice(:domonkai_id, :first_name, :last_name, :japanese_last_name, :japanese_last_name, :fax, :email, :phone, :tea_name, :japanese_tea_name, :language)

      member
    end
  end

  def open_spreadsheet
    case File.extname(file.original_filename)
    when ".csv" then Roo::CSV.new(file.path, csv_options: {encoding: "utf-8"})
    when ".xls" then Roo::Excel.new(file.path, nil, :ignore)
    when ".xlsx" then Roo::Excelx.new(file.path, nil, :ignore)
    else raise "Unknown file type: #{file.original_filename}"
    end
  end
end
