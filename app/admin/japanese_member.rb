ActiveAdmin.register JapaneseMember do
  # allow these params to be updated
  permit_params :domonkai_id, :first_name, :last_name,
                :japanese_first_name, :japanese_last_name, :tea_name, :japanese_tea_name,
                :email, :sex, :address, :city, :state, :zip, :country, :phone, :fax , :sensei_member_id,
                :shikaku_kubun_id

  title =  "会員名簿"
  menu priority: 5, label: title
  #active_admin_import


  config.per_page = 100
  controller do
    before_filter { @page_title = title }
    def scoped_collection
      super.includes :shikaku_kubun  # prevents N+1 queries to your database
    end
  end

  #actions :all, :except => [:new, :create, :destroy]



  # default sort column
  config.sort_order = :domonkai_id

  # displays the site_id but uses site_info_id for the query
  # if heroku does not work comment out
  filter :shikaku_kubun_id, :as => :select, :collection => ShikakuKubun.all.collect {|s| [s.japanese_name, s.id]}, :label => Constants::JAPANESE_SHIKAKU_LABEL
  filter :sensei_member_id, :as => :select, :collection => Member.where(shikaku_kubun_id:  1).collect {|m| [m.japanese_last_name, m.id]} , :label => Constants::JAPANESE_SHACHU_LABEL
  filter :first_name
  filter :last_name
  filter :japanese_first_name, :label => Constants::JAPANESE_FIRSTNAME_LABEL
  filter :japanese_last_name, :label => Constants::JAPANESE_LASTNAME_LABEL
  filter :domonkai_id, :label => Constants::DOMONKAI_ID_LABEL

  index do
    selectable_column
    column Constants::DOMONKAI_ID_LABEL, :domonkai_id
    column Constants::JAPANESE_SHACHU_LABEL, sortable: 'sensei_member_id'  do |member|
      unless member.shachu.nil?
        member.shachu.japanese_last_name
      else
        member.shachu
      end
    end

    column Constants::JAPANESE_SHIKAKU_LABEL , sortable: 'shikaku_kubuns.name' do |member|
      member.shikaku_kubun_japanese_name
    end
    column '名前', :japanese_last_name
    column '苗字', :japanese_first_name
    column :email
    column :phone  do |member|
      number_to_phone(member.phone, area_code: true)
    end
    column Constants::JAPANESE_ADDRESS_LABEL do |member|
      member.address.to_s + ' ' + member.city.to_s + ' ' + member.state.to_s + ' ' + member.zip.to_s
    end
    actions
  end

  form do |f|
    f.inputs do
      f.input :domonkai_id, :label => Constants::DOMONKAI_ID_LABEL
      f.input :last_name, :as => :string, :include_blank => false
      f.input :first_name, :as => :string, :include_blank => false
      f.input :japanese_last_name, :as => :string, :include_blank => false, :label => Constants::JAPANESE_LASTNAME_LABEL
      f.input :japanese_first_name, :as => :string, :include_blank => false, :label => Constants::JAPANESE_FIRSTNAME_LABEL
      f.input :tea_name, :as => :string, :include_blank => false
      f.input :japanese_tea_name, :as => :string, :include_blank => false, :label => Constants::JAPANESE_CHAMEI_LABEL
      f.input :email
      f.input :sex, :as => :select, :collection => ['Male', 'Female', 'N/A'], :include_blank => false, :label => Constants::JAPANESE_SEX_LABEL
      f.input :address
      f.input :city
      f.input :state
      f.input :zip
      f.input :country , :as => :string
      f.input :phone
      f.input :fax
      f.input :sensei_member_id, :include_blank => true, :as => :select, :collection => Member.where(shikaku_kubun_id: 1).collect {|m| [m.japanese_last_name, m.id]} , :label => Constants::JAPANESE_SHACHU_LABEL
      f.input :shikaku_kubun_id, :include_blank => false, :as => :select, :collection => ShikakuKubun.all.collect {|m| [m.japanese_name, m.id]} , :label => Constants::JAPANESE_SHIKAKU_LABEL

    end
    f.actions
  end

  show do |member|
    attributes_table do
      row Constants::DOMONKAI_ID_LABEL do
        member.domonkai_id
      end
      row :last_name
      row :first_name
      row Constants::JAPANESE_LASTNAME_LABEL do
        member.japanese_last_name
      end
      row Constants::JAPANESE_FIRSTNAME_LABEL do
        member.japanese_first_name
      end
      row :tea_name
      row Constants::JAPANESE_CHAMEI_LABEL do
        member.japanese_tea_name
      end
      row :email
      row Constants::JAPANESE_SEX_LABEL do
        member.sex
      end
      row :address
      row :city
      row :state
      row :zip
      row :country
      row :phone do
        number_to_phone(member.phone, area_code: true)
      end
      row :fax
      row Constants::JAPANESE_SHACHU_LABEL do |member|
        unless member.shachu.nil?
          member.shachu.japanese_last_name
        else
          member.shachu
        end
      end

      row Constants::JAPANESE_SHIKAKU_LABEL do |member|
        member.shikaku_kubun_japanese_name
      end
    end

  end

  action_item only: :index do
    link_to "Import Members", new_member_imports_path
  end

  sidebar :Download do
    ul do
      li link_to "All Members", members_path(format: "xls", shikaku: "all")
      li link_to "All Kyouju-sha", members_path(format: "xls", shikaku: "kyouju")
      li link_to "All Koushi ", members_path(format: "xls", shikaku: "koushi")
      li link_to "All Ippan Members", members_path(format: "xls", shikaku: "ippan")
    end
  end
end