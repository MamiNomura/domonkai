class MembersController < ApplicationController


  def index
    logger.info "params shikaku #{params[:shikaku]}"
    case params[:shikaku]
      when "kyouju"
        @members = Member.where( shikaku_kubun_id: [1,2]).order(:domonkai_id)
      when "koushi"
        @members = Member.where( shikaku_kubun_id: 3).order(:domonkai_id)
      when "ippan"
        @members = Member.where( shikaku_kubun_id: 4).order(:domonkai_id)
      else
        @members = Member.order(:domonkai_id)
    end

    logger.info "members is #{@members}"
    # export
    respond_to do |format|
      format.csv { send_data @members.to_csv }
      format.xls # { send_data @members.to_csv(col_sep: "\t") }
    end
  end

  def import
    Member.import(params[:file])
    redirect_to admin_member_url, notice: "Members imported."
  end
end

