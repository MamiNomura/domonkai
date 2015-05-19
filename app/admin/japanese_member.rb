ActiveAdmin.register JapaneseMember do
  # allow these params to be updated
  permit_params :domonkai_id, :join_date, :first_name, :last_name,
                :japanese_first_name, :japanese_last_name, :tea_name, :japanese_tea_name,
                :email, :sex, :address, :city, :state, :zip, :country, :phone, :fax , :sensei_member_id,
                :shikaku_kubun_id


  active_admin_importable

  DOMONKAI_ID_LABEL = 'ID'
  SHIKAKU_LABEL = 'Shikaku'
  SHACHU_LABEL = 'Shachu'
  JAPANESE_ADDRESS_LABEL = "住所"
  JAPANESE_LASTNAME_LABEL = "苗字 （Last Name)"
  JAPANESE_FIRSTNAME_LABEL = "名前 (First Name)"
  JAPANESE_CHAMEI_LABEL = "茶名"
  JAPANESE_SHACHU_LABEL =  "社中"
  JAPANESE_SHIKAKU_LABEL = "資格区分"
  JAPANESE_SEX_LABEL = "性別"
  title =  "会員名簿"


  config.per_page = 100
  controller do
    before_filter { @page_title = title }
    def scoped_collection
      super.includes :shikaku_kubun  # prevents N+1 queries to your database
    end
  end

  #actions :all, :except => [:new, :create, :destroy]

  menu label: title

  # default sort column
  config.sort_order = :domonkai_id

  # displays the site_id but uses site_info_id for the query
  filter :shikaku_kubun_id, :as => :select, :collection => ShikakuKubun.all.collect {|s| [s.japanese_name, s.id]}, :label => JAPANESE_SHIKAKU_LABEL
  filter :sensei_member_id, :as => :select, :collection => Member.where(shikaku_kubun_id:  1).collect {|m| [m.japanese_last_name, m.id]} , :label => JAPANESE_SHACHU_LABEL
  filter :first_name
  filter :last_name
  filter :japanese_first_name, :label => JAPANESE_FIRSTNAME_LABEL
  filter :japanese_last_name, :label => JAPANESE_LASTNAME_LABEL
  filter :domonkai_id, :label => DOMONKAI_ID_LABEL

  index do
    selectable_column
    column DOMONKAI_ID_LABEL, :domonkai_id
    column JAPANESE_SHACHU_LABEL, sortable: 'sensei_member_id'  do |member|
      unless member.shachu.nil?
        member.shachu.japanese_last_name
      else
        member.shachu
      end
    end

    column JAPANESE_SHIKAKU_LABEL , sortable: 'shikaku_kubuns.name' do |member|
      member.shikaku_kubun.japanese_name
    end
    column '名前', :japanese_last_name
    column '苗字', :japanese_first_name
    column :email
    column :phone  do |member|
      number_to_phone(member.phone, area_code: true)
    end
    column JAPANESE_ADDRESS_LABEL do |member|
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
      f.input :sex, :as => :select, :collection => ['Male', 'Female', 'N/A'], :include_blank => false, :label => JAPANESE_SEX_LABEL
      f.input :address
      f.input :city
      f.input :state
      f.input :zip
      f.input :country , :as => :string
      f.input :phone
      f.input :fax
      f.input :sensei_member_id, :include_blank => true, :as => :select, :collection => Member.where(shikaku_kubun_id: 1).collect {|m| [m.japanese_last_name, m.id]} , :label => JAPANESE_SHACHU_LABEL
      f.input :shikaku_kubun_id, :include_blank => false, :as => :select, :collection => ShikakuKubun.all.collect {|m| [m.japanese_name, m.id]} , :label => JAPANESE_SHIKAKU_LABEL

    end
    f.actions
  end

  show do |member|
    attributes_table do
      row DOMONKAI_ID_LABEL do
        member.domonkai_id
      end
      row :join_date
      row :last_name
      row :first_name
      row JAPANESE_LASTNAME_LABEL do
        member.japanese_last_name
      end
      row JAPANESE_FIRSTNAME_LABEL do
        member.japanese_first_name
      end
      row :tea_name
      row JAPANESE_CHAMEI_LABEL do
        member.japanese_tea_name
      end
      row :email
      row JAPANESE_SEX_LABEL do
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
      row JAPANESE_SHACHU_LABEL do |member|
        unless member.shachu.nil?
          member.shachu.japanese_last_name
        else
          member.shachu
        end
      end

      row JAPANESE_SHIKAKU_LABEL do |member|
        member.shikaku_kubun.japanese_name
      end
    end

  end
end