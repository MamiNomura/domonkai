class DouguImportsController < ApplicationController

  def new
    @dougu_import = DouguImport.new

  end

  def create
    @dougu_import = DouguImport.new(params[:dougu_import])
    if @dougu_import.save
      redirect_to admin_dougus_url, notice: "Imported dougus successfully."
    else
      render :new
    end
  end
end
