ActiveAdmin.register DouguCategory do
  permit_params :name, :japanese_name
  before_filter :skip_sidebar!, :only => :index
  menu priority: 8 , :parent => "Dougu"
  index do
    selectable_column
    column :name
    column :japanese_name
    actions
  end

  form do |f|
    f.inputs "Dougu Category" do
      f.input :name
      f.input :japanese_name
    end
    f.actions
  end

end
