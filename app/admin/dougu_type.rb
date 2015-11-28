ActiveAdmin.register DouguType do
  permit_params :name, :japanese_name, :description
  before_filter :skip_sidebar!, :only => :index
  menu priority: 9 , :parent => "Dougu"


  index do
    selectable_column
    column :name
    column :japanese_name
    column :description
    actions
  end

  form do |f|
    f.inputs "Dougu Type" do
      f.input :name
      f.input :japanese_name
      f.input :description , :as => :html_editor
    end
    f.actions
  end


  action_item only: :index do
    link_to "Import Types", new_dougu_type_imports_path
  end
end
