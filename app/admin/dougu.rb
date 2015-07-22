#encoding: utf-8
ActiveAdmin.register Dougu do

  # allow these params to be updated
  permit_params :dougu_category_id, :dougu_type_id, :dougu_sub_type_id,
                :name, :japanese_name, :description,
                :location, :last_checked, :image_one, :image_two, :image_three

  title =  "Dougu (道具)"

  menu priority: 11, label: title, :parent => "Dougu"

  config.per_page = 30
  #index :download_links => [:csv, :xlsx]

  # default sort column
  config.sort_order = :dougu_category_id, :dougu_type_id, :dougu_sub_type_id

  # displays the site_id but uses site_info_id for the query
  # todo: comment out here before db migration
  filter :dougu_category_id, :as => :select, :collection => DouguCategory.all.collect {|s| [s.pretty_name, s.id]}, :label => 'Category'
  filter :dougu_type_id, :as => :select, :collection => DouguType.all.collect {|s| [s.pretty_name, s.id]}, :label => 'Type'
  filter :dougu_sub_type_id, :as => :select, :collection => DouguSubType.all.collect {|s| [s.pretty_name, s.id]} , :label => 'Sub Type'

  filter :name
  filter :japanese_name, :label => '日本語名'
  filter :record_updated
  filter :last_checked

  controller do
    before_filter { @page_title = title }
    def scoped_collection
      super.includes :dougu_type, :dougu_category, :dougu_sub_type # prevents N+1 queries to your database
    end
  end


  index do
    selectable_column
    column "Image" do |dougu|
      link_to(image_tag(dougu.image_one.url(:thumb), :height => '100'), admin_dougu_path(dougu))
    end

    column 'Type', sortable: 'dougu_types.name' do |dougu|
      dougu.dougu_type.pretty_name
    end


    column 'Name', sortable: 'name' do |d|
      d.pretty_name.to_s
    end

    actions

  end



  form :html => { :enctype => "multipart/form-data" } do |f|
    f.inputs do
      f.input :dougu_category_id, :include_blank => false, :as => :select, :collection => DouguCategory.all.collect {|m| [m.pretty_name, m.id]} , :label => 'Category'
      f.input :dougu_type_id, :include_blank => false, :as => :select, :collection => DouguType.all.collect {|m| [m.pretty_name, m.id]} , :label => 'Type'
      f.input :dougu_sub_type_id, :include_blank => true, :as => :select, :collection => DouguSubType.all.collect {|m| [m.pretty_name, m.id]} , :label => 'SubType'
      f.input :name, :as => :string, :include_blank => false
      f.input :japanese_name, :as => :string, :include_blank => false
      f.input :description
      f.input :location
      f.input :last_checked, :as => :datepicker
      f.input :image_one, :required => false, :as => :file, :hint => image_tag(f.object.image_one.url(:thumb))
      f.input :image_two, :required => false, :as => :file, :hint => image_tag(f.object.image_two.url(:thumb))
      f.input :image_three, :required => false, :as => :file, :hint => image_tag(f.object.image_three.url(:thumb))

    end
    f.actions
  end


  show do |dougu|
    attributes_table do
      row "Category"  do
        if dougu.dougu_category.nil?
          dougu.dougu_category
        else
          dougu.dougu_category.pretty_name
        end

      end
      row "Type" do
        if dougu.dougu_type.nil?
          dougu.dougu_type
        else
          dougu.dougu_type.pretty_name
        end
      end
      row "SubType" do
        if dougu.dougu_sub_type.nil?
          dougu.dougu_sub_type
        else
          dougu.dougu_sub_type.pretty_name
        end

      end
      row :name
      row :japanese_name
      row :description
      row :location
      row :last_checked
      row "Image" do
        image_tag(dougu.image_one.url(:medium))
      end

      row "Image 2" do
        image_tag(dougu.image_two.url(:medium))
      end

      row "Image 3" do
        image_tag(dougu.image_three.url(:medium))
      end


    end

    active_admin_comments
  end



end