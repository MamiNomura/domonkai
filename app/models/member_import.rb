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
      member = Member.find_by(domonkai_id: row["domonkai_id"]) || Member.new
      # remove .0 from zip
      row["zip"] = row["zip"].to_s.sub(/.0$/, '')
      attributes = row.to_hash.slice(*Member.allowed_attributes)
      unless row["shachu"].nil?
        sensei = Member.find_by(last_name: row["shachu"])
        unless sensei.nil?
          attributes[:sensei_member_id] = sensei.id
        end
      end
      member.attributes = attributes
      member
    end
  end

  def open_spreadsheet
    case File.extname(file.original_filename)
    when ".csv" then Roo::CSV.new(file.path, csv_options: {encoding: "utf-8"})
    when ".xls" then Roo::Excel.new(file.path, file_warning: :ignore)
    when ".xlsx" then Roo::Excelx.new(file.path, file_warning: :ignore)
    else raise "Unknown file type: #{file.original_filename}"
    end
  end
end
