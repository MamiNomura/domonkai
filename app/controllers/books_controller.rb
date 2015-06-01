class BooksController < ApplicationController

  def show
    @members = Member.order(:last_name)
    respond_to do |format|
      format.pdf do
        pdf = BookPdf.new(@members, view_context)
        send_data pdf.render, filename: "domonkai-book.pdf",
                  type: "application/pdf",
                  disposition: "inline"
      end
    end
  end

end