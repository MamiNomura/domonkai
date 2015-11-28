class DouguTypeImport
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
    if imported_dougu_types.map(&:valid?).all?
      imported_dougu_types.each(&:save!)
      true
    else
      imported_dougu_types.each_with_index do |dougu_type, index|
        dougu_type.errors.full_messages.each do |message|
          errors.add :base, "Row #{index+2}: #{message}"
        end
      end
      false
    end
  end

  def imported_dougu_types
    @imported_dougu_types ||= load_import_type
  end

  def load_import_type
    spreadsheet = open_spreadsheet
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).map do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      type = DouguType.find_by(name: row["name"]) || DouguType.new
      # remove .0 from zip
      attributes = row.to_hash.slice(*DouguType.allowed_attributes)

      type.attributes = attributes
      type
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
