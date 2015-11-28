class DouguTypeImportsController < ApplicationController

  def new
    @dougu_type_import = DouguTypeImport.new

  end

  def create
    @dougu_type_import = DouguTypeImport.new(params[:dougu_type_import])
    if @dougu_type_import.save
      redirect_to admin_dougu_types_url, notice: "Imported dougu type successfully."
    else
      render :new
    end
  end
end
