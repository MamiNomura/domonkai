ActiveAdmin.register DouguType do
  permit_params :name, :japanese_name, :description, :dougu_category_id
  before_filter :skip_sidebar!, :only => :index
  menu priority: 9 , :parent => "Dougu"


  index do
    selectable_column
    column "Category", sortable: 'dougu_categories.name' do |dougu_type|
      dougu_type.dougu_category.name + ' (' + dougu_type.dougu_category.japanese_name + ')'
    end

    column :name
    column :japanese_name
    actions
  end

  form do |f|
    f.inputs "Dougu Type" do
      f.input :dougu_category_id, :include_blank => false, :as => :select, :collection => DouguCategory.all.collect { |c| [c.name + ' (' +c.japanese_name + ')', c.id]} , :label => 'Type'
      f.input :name
      f.input :japanese_name
    end
    f.actions
  end

end
