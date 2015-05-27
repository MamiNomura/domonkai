ActiveAdmin.register ShikakuKubun do
  permit_params :name, :japanese_name
  before_filter :skip_sidebar!, :only => :index
  menu priority: 6
  index do
    selectable_column
    id_column
    column :name
    column :japanese_name
    actions
  end

  form do |f|
    f.inputs "Shikaku Kubun Details" do
      f.input :name
      f.input :japanese_name
    end
    f.actions
  end

end
