
class MembersController < ApplicationController
  def export
    @data = Member.all

    book = Spreadsheet::Workbook.new
    sheet = book.create_worksheet :name => "Membership"

    contruct_body(sheet, @data)

    spreadsheet = StringIO.new
    book.write spreadsheet
    send_data spreadsheet.string, :filename => "domonkai.xls", :type =>  "application/vnd.ms-excel"

  end
end