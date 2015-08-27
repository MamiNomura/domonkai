ActiveAdmin.register DouguType do
  permit_params :name, :japanese_name, :description
  before_filter :skip_sidebar!, :only => :index
  menu priority: 9 , :parent => "Dougu"


  index do
    selectable_column
    column :name
    column :japanese_name
    actions
  end

  form do |f|
    f.inputs "Dougu Type" do
      f.input :name
      f.input :japanese_name
    end
    f.actions
  end

end
