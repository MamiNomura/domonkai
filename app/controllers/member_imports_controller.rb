class MemberImportsController < ApplicationController

  def new
    @member_import = MemberImport.new

  end

  def create
    @member_import = MemberImport.new(params[:member_import])
    if @member_import.save
      redirect_to admin_members_url, notice: "Imported members successfully."
    else
      render :new
    end
  end
end
