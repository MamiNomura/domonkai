class DouguSubTypeImportsController < ApplicationController

  def new
    @dougu_sub_type_import = DouguSubTypeImport.new

  end

  def create
    @dougu_sub_type_import = DouguSubTypeImport.new(params[:dougu_sub_type_import])
    if @dougu_sub_type_import.save
      redirect_to admin_dougu_sub_types_url, notice: "Imported dougu sub type successfully."
    else
      render :new
    end
  end
end
