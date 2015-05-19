class MembersController < ApplicationController


  def index
    @members = Member.order(:domonkai_id)
    respond_to do |format|
      format.csv { send_data @members.to_csv }
      format.xls # { send_data @members.to_csv(col_sep: "\t") }
    end
  end


end

