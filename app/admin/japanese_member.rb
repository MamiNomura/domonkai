ActiveAdmin.register JapaneseMember do
  # allow these params to be updated
  permit_params :domonkai_id, :join_date, :first_name, :last_name,
                :japanese_first_name, :japanese_last_name, :tea_name, :japanese_tea_name,
                :email, :sex, :address, :city, :state, :zip, :country, :phone, :fax , :sensei_member_id,
                :shikaku_kubun_id

  config.per_page = 100

  #actions :all, :except => [:new, :create, :destroy]

  menu label: "名簿"

  # default sort column
  config.sort_order = :domonkai_id

  # displays the site_id but uses site_info_id for the query
  filter :shikaku_kubun_id, :as => :select, :collection => ShikakuKubun.all.collect {|s| [s.japanese_name, s.id]}, :label => '資格者区分'
  filter :sensei_member_id, :as => :select, :collection => Member.all.collect {|m| [m.japanese_last_name, m.id]} , :label => '社中名'
  filter :first_name
  filter :last_name
  filter :japanese_first_name, :label => '苗字'
  filter :japanese_last_name, :label => '名前'
  filter :domonkai_id, :label => 'Domonkai ID'

  index do
    selectable_column
    column 'ID', :domonkai_id
    column '社中' do |member|
      member.shachu.japanese_last_name
    end
    column '資格者区分' do |member|
      member.shikaku_kubun.japanese_name
    end
    column '名前', :japanese_last_name
    column '苗字', :japanese_first_name
    column :email
    column :phone
    column '住所' do |member|
      member.address + ' ' + member.city + ' ' + member.state + ' ' + member.zip
    end
    actions
  end

  form do |f|
    f.inputs do
      f.input :domonkai_id, :label => "Domonkai id"
      f.input :join_date,   :as => :datepicker
      f.input :last_name, :as => :string, :include_blank => false
      f.input :first_name, :as => :string, :include_blank => false
      f.input :japanese_last_name, :as => :string, :include_blank => false, :label => "苗字"
      f.input :japanese_first_name, :as => :string, :include_blank => false, :label => "名前"
      f.input :tea_name, :as => :string, :include_blank => false
      f.input :japanese_tea_name, :as => :string, :include_blank => false, :label => "茶名"
      f.input :email
      f.input :sex, :as => :select, :collection => ['Male', 'Female', 'N/A'], :include_blank => false
      f.input :address
      f.input :city
      f.input :state
      f.input :zip
      f.input :country , :as => :string
      f.input :phone
      f.input :fax
      f.input :sensei_member_id, :include_blank => true, :as => :select, :collection => Member.all.collect {|m| [m.japanese_last_name, m.id]} , :label => '社中'
      f.input :shikaku_kubun_id, :include_blank => false, :as => :select, :collection => ShikakuKubun.all.collect {|m| [m.japanese_name, m.id]} , :label => 'Shikakusha-kubun'

    end
    f.actions
  end

  show do |member|
    attributes_table do
      row :domonkai_id
    end

    active_admin_comments
  end

end