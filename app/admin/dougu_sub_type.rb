ActiveAdmin.register DouguSubType do
  permit_params :name, :japanese_name, :dougu_type_id
  before_filter :skip_sidebar!, :only => :index
  menu priority: 10 , :parent => "Dougu"


  index do
    selectable_column
    column "Type", sortable: 'dougu_types.name' do |st|
      st.dougu_type.name + ' (' + st.dougu_type.japanese_name + ')'
    end

    column :name
    column :japanese_name
    actions
  end

  form do |f|
    f.inputs "Dougu Sub Type" do
      f.input :dougu_type_id, :include_blank => false, :as => :select, :collection => DouguType.all.collect { |c| [c.name + ' (' +c.japanese_name + ')', c.id]} , :label => 'Sub Type'
      f.input :name
      f.input :japanese_name
    end
    f.actions
  end

end
