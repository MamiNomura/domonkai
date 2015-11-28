class DouguImport
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
    if imported_dougus.map(&:valid?).all?
      imported_dougus.each(&:save!)
      true
    else
      imported_dougus.each_with_index do |member, index|
        member.errors.full_messages.each do |message|
          errors.add :base, "Row #{index+2}: #{message}"
        end
      end
      false
    end
  end

  def imported_dougus
    @imported_dougus ||= load_imported_dougus
  end

  def load_imported_dougus
    spreadsheet = open_spreadsheet
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).map do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      dougu = Dougu.find_by(name: row["name"]) || Dougu.new

      attributes = row.to_hash.slice(*Dougu.allowed_attributes)
      unless row["type"].nil?
        type = DouguType.find_by(name: row["type"])
        unless type.nil?
          attributes[:dougu_type_id] = type.id
        end
      end
      unless row["sub_type"].nil?
        sub_type = DouguSubType.find_by(name: row["sub_type"])
        unless sub_type.nil?
          attributes[:dougu_sub_type_id] = sub_type.id
        end
      end
      dougu.attributes = attributes
      dougu
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
