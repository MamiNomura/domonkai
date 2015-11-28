ActiveAdmin.register DouguSubType do
  permit_params :name, :japanese_name, :dougu_type_id
  before_filter :skip_sidebar!, :only => :index
  menu priority: 10 , :parent => "Dougu"


  index do
    selectable_column
    column "Type", sortable: 'dougu_type.name' do |st|
      unless st.dougu_type.nil?
        st.dougu_type.name + ' (' + st.dougu_type.japanese_name + ')'
      end

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

  action_item only: :index do
    link_to "Import Sub Types", new_dougu_sub_type_imports_path
  end

end
