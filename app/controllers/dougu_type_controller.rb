class DouguTypeController < ApplicationController


  def import
    DouguType.import(params[:file])
    redirect_to admin_dougu_type_url, notice: "Types imported."
  end
end

