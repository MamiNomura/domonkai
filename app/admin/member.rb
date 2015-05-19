#encoding: utf-8
ActiveAdmin.register Member do
  # allow these params to be updated
  permit_params :domonkai_id, :join_date, :first_name, :last_name,
                :japanese_first_name, :japanese_last_name, :tea_name, :japanese_tea_name,
                :email, :sex, :address, :city, :state, :zip, :country, :phone, :fax , :sensei_member_id,
                :shikaku_kubun_id

  config.per_page = 100
  #index :download_links => [:csv, :xlsx]

  # active_admin_import :validate => true,
  #                     :template_object => ActiveAdminImport::Model.new(
  #                         :hint => "file will be imported with such header format: 'body','title','author'",
  #                         :csv_headers => ["body","title","author"]
  #                     )

  active_admin_import validate: false,
                      # before_batch_import: proc { |import|
                      #   puts import.file #current file used
                      #   puts import.resource #ActiveRecord class to import to
                      #   puts import.options # options
                      #   puts import.result # result before bulk iteration
                      #   puts import.headers # CSV headers
                      #   puts import.csv_lines #lines to import
                      #   puts import.model #template_object instance
                      # },
                      template_object: ActiveAdminImport::Model.new(
                          force_encoding: :auto
                      )


  # xlsx(:header_style => {:bg_color => 'C0BFBF', :fg_color => '000000' }) do
  #   delete_columns :id, :created_at, :updated_at
  # end

  #actions :all, :except => [:new, :create, :destroy]

  #menu :parent => "Member"

  # default sort column
  config.sort_order = :domonkai_id

  DOMONKAI_ID_LABEL = 'ID'
  SHIKAKU_LABEL = 'Shikaku'
  SHACHU_LABEL = 'Shachu'
  ADDRESS_LABEL = 'address'
  JAPANESE_LASTNAME_LABEL = "苗字 （Japanese Last Name)"
  JAPANESE_FIRSTNAME_LABEL = "名前 (Japanese First Name)"
  JAPANESE_CHAMEI_LABEL = "茶名"
  JAPANESE_SHACHU_LABEL =  '社中'


  # displays the site_id but uses site_info_id for the query
  filter :shikaku_kubun_id, :as => :select, :collection => ShikakuKubun.all.collect {|s| [s.name, s.id]}, :label => SHIKAKU_LABEL
  filter :sensei_member_id, :as => :select, :collection => Member.all.collect {|m| [m.last_name, m.id]} , :label => SHACHU_LABEL
  filter :first_name
  filter :last_name
  filter :domonkai_id, :label => DOMONKAI_ID_LABEL

  controller do
    def scoped_collection
      super.includes :shikaku_kubun  # prevents N+1 queries to your database
    end
  end

  index do
    selectable_column
    column DOMONKAI_ID_LABEL, :domonkai_id
    column SHACHU_LABEL, sortable: 'sensei_member_id'  do |member|
      unless member.shachu.nil?
        member.shachu.last_name

      else
        member.shachu
      end

    end

    column SHIKAKU_LABEL , sortable: 'shikaku_kubuns.name' do |member|
      member.shikaku_kubun.name
    end
    column :last_name
    column :first_name
    column :email
    column :phone do |member|
      number_to_phone(member.phone, area_code: true)
    end
    column ADDRESS_LABEL do |member|
      member.address + ' ' + member.city + ' ' + member.state + ' ' + member.zip
    end

    actions
  end

  form do |f|
    f.inputs do
      f.input :domonkai_id, :label => DOMONKAI_ID_LABEL
      f.input :join_date,   :as => :datepicker
      f.input :last_name, :as => :string, :include_blank => false
      f.input :first_name, :as => :string, :include_blank => false
      f.input :japanese_last_name, :as => :string, :include_blank => false, :label => JAPANESE_LASTNAME_LABEL
      f.input :japanese_first_name, :as => :string, :include_blank => false, :label => JAPANESE_FIRSTNAME_LABEL
      f.input :tea_name, :as => :string, :include_blank => false
      f.input :japanese_tea_name, :as => :string, :include_blank => false, :label => JAPANESE_CHAMEI_LABEL
      f.input :email
      f.input :sex, :as => :select, :collection => ['Male', 'Female', 'N/A'], :include_blank => false
      f.input :address
      f.input :city
      f.input :state
      f.input :zip
      f.input :country , :as => :string
      f.input :phone
      f.input :fax
      f.input :sensei_member_id, :include_blank => true, :as => :select, :collection => Member.all.collect {|m| [m.last_name, m.id]} , :label => SHACHU_LABEL
      f.input :shikaku_kubun_id, :include_blank => false, :as => :select, :collection => ShikakuKubun.all.collect {|m| [m.name, m.id]} , :label => SHIKAKU_LABEL

    end
    f.actions
  end

  show do |member|
    attributes_table do
      row :domonkai_id ,  :label => DOMONKAI_ID_LABEL
      row :join_date
      row :last_name
      row :first_name
      row :japanese_last_name
      row :japanese_first_name
      row :tea_name
      row :japanese_tea_name
      row :email
      row :sex
      row :address
      row :city
      row :state
      row :zip
      row :country
      row :phone do
        number_to_phone(member.phone, area_code: true)
      end
      row :fax
      row SHACHU_LABEL do
        unless member.shachu.nil?
          member.shachu.last_name
        else
          member.shachu
        end
      end

      row SHIKAKU_LABEL do
        member.shikaku_kubun.name
      end

    end

    active_admin_comments
  end


  action_item only: :index do
    link_to "Download Excel", members_path(format: "xls")
  end

  index :download_links => false do
    # off standard download link
  end

end