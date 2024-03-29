#encoding: utf-8
ActiveAdmin.register Dougu do

  # allow these params to be updated
  permit_params :dougu_type_id, :name, :japanese_name, :description,
                :location, :last_checked,
                :image_link_one, :image_link_two, :image_link_three,
                :_wysihtml5_mode,

  title =  "Dougu (道具)"

  menu priority: 11, label: title, :parent => "Dougu"

  config.per_page = 30
  #index :download_links => [:csv, :xlsx]

  # default sort column
  config.sort_order = 'dougu_types.name_asc'
  config.comments = false

  # displays the site_id but uses site_info_id for the query
  # todo: comment out here before db migration
  filter :dougu_type_id, :as => :select, :collection => DouguType.all.order(:name).collect {|s| [s.pretty_name, s.id]}, :label => 'Type'
  filter :name
  filter :japanese_name, :label => '日本語名'
  filter :record_updated
  filter :last_checked

  controller do
    before_action { @page_title = title }
    def scoped_collection
      super.includes :dougu_type # prevents N+1 queries to your database
    end
  end


  index do
    selectable_column

    column "Image" do |dougu|
      link_to(image_tag(dougu.image_link_one, :height => '100'), admin_dougu_path(dougu))
    end

    column 'Type', sortable: 'dougu_types.name' do |dougu|
      unless dougu.dougu_type.nil?
        result = dougu.dougu_type.pretty_name
      end

      raw(result)

    end


    column 'Name', sortable: 'name' do |dougu|
      field = dougu.pretty_name.to_s + '<br/>'+ dougu.description
      raw(field)
    end

    actions

  end



  form :html => { :enctype => "multipart/form-data" } do |f|
    f.semantic_errors
    f.inputs do
      f.input :dougu_type_id, :include_blank => false, :as => :select, :collection => DouguType.all.order(:name).collect {|m| [m.pretty_name, m.id]} , :label => 'Type'
      f.input :name, :as => :string, :include_blank => false
      f.input :japanese_name, :as => :string, :include_blank => false
      f.input :description, :as => :quill_editor
      f.input :location
      f.input :last_checked, :as => :datepicker
      f.input :image_link_one, :required => false
      f.input :image_link_two, :required => false
      f.input :image_link_three, :required => false
    end
    f.actions
  end


  show do |dougu|
    attributes_table do
      row "Type" do
        if dougu.dougu_type.nil?
          dougu.dougu_type
        else
          dougu.dougu_type.pretty_name
        end
      end

      row :name
      row :japanese_name
      row "Description" do
        raw(dougu.description)
      end
      row :location
      row :last_checked
      row "Image Link 1" do
        image_tag(dougu.image_link_one)
      end
      row "Image Link 2" do
        image_tag(dougu.image_link_two)
      end
      row "Image Link 3" do
        image_tag(dougu.image_link_three)
      end

    end

    active_admin_comments
  end


  action_item only: :index do
    link_to "Import  Dougu", new_dougu_imports_path
  end

end
