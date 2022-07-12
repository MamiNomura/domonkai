ActiveAdmin.register JapaneseMember do
  # allow these params to be updated
  permit_params :domonkai_id, :first_name, :last_name,
                :japanese_first_name, :japanese_last_name, :tea_name, :japanese_tea_name,
                :email, :sex, :address, :city, :state, :zip, :country, :phone, :fax , :sensei_member_id,
                :shikaku_kubun_id, :record_updated, :language, :yakuin

  title =  "会員名簿"
  menu priority: 5, label: title, :parent => "Membership"
  #active_admin_import

  scope :all, default: true
  scope Constants::KOJIN, :kojin
  scope Constants::KYOJU, :kyoju
  scope Constants::SHIKAKUSHA, :shikaku
  scope Constants::IPPAN, :ippan

  config.per_page = 30
  controller do
    before_action { @page_title = title }
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
  filter :sensei_member_id, :as => :select, :collection => Member.where(shikaku_kubun_id:  [1,2]).order(:last_name).collect {|m| [m.japanese_last_name + ' ' + m.japanese_first_name, m.id]} , :label => Constants::JAPANESE_SHACHU_LABEL
  filter :first_name
  filter :last_name
  filter :email
  filter :japanese_first_name, :label => Constants::JAPANESE_FIRSTNAME_LABEL
  filter :japanese_last_name, :label => Constants::JAPANESE_LASTNAME_LABEL
  filter :domonkai_id, :label => Constants::DOMONKAI_ID_LABEL
  filter :record_updated
  filter :yakuin, :label => Constants::JAPANESE_YAKUIN_LABEL

  index do
    selectable_column
    column Constants::DOMONKAI_ID_LABEL, :domonkai_id
    column Constants::JAPANESE_SHACHU_LABEL, sortable: 'sensei_member_id'  do |member|
      unless member.shachu.nil?
        member.shachu.japanese_last_name + ' ' + member.shachu.japanese_first_name
      else
        member.shachu
      end
    end

    column Constants::JAPANESE_SHIKAKU_LABEL , sortable: 'shikaku_kubuns.name' do |member|
      member.shikaku_kubun_japanese_name
    end

    column Constants::JAPANESE_NAME_LABEL , sortable: 'last_name' do |member|
      member.japanese_last_name.to_s + ' ' + member.japanese_first_name.to_s
    end

    column Constants::INFO_LABEL , sortable: 'city' do |member|
      raw(member.address.to_s + ' <br/>' + member.city.to_s + ' ' + member.state.to_s + ' ' + member.zip.to_s +
              '<br/> ' + number_to_phone(member.phone, area_code: true).to_s + '<br/> ' + mail_to(member.email.to_s))

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
      f.input :sensei_member_id, :include_blank => true, :as => :select, :collection => Member.where(shikaku_kubun_id: [1,2]).order(:last_name).collect {|m| [m.japanese_last_name + ' ' + m.japanese_first_name, m.id]} , :label => Constants::JAPANESE_SHACHU_LABEL
      f.input :shikaku_kubun_id, :include_blank => false, :as => :select, :collection => ShikakuKubun.all.collect {|m| [m.japanese_name, m.id]} , :label => Constants::JAPANESE_SHIKAKU_LABEL
      f.input :language
      f.input :record_updated
      f.input :yakuin , :label => Constants::JAPANESE_YAKUIN_LABEL
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
          member.shachu.japanese_last_name + ' ' + member.shachu.japanese_first_name
        else
          member.shachu
        end
      end

      row Constants::JAPANESE_SHIKAKU_LABEL do |member|
        member.shikaku_kubun_japanese_name
      end
      row :language
      row :record_updated
      row Constants::JAPANESE_YAKUIN_LABEL do |member|
        member.yakuin
      end
    end
    active_admin_comments

  end


  # batch actions
  batch_action :send_emails do |ids|
    @members = []
    Member.find(ids).each do |member|
      @members << member
    end
    render :mylist
  end

  batch_action :destroy, false

  batch_action :edit_members, form: {
                             RECORD_UPDATED: %w[true false]
                         } do |selection, inputs|


    Member.where(:id => selection).update_all(record_updated: inputs[:RECORD_UPDATED]) # ':id => selection' same as 'id in (selection)'
    redirect_to collection_path, notice: "States of selected members have been successfully modified!"


  end


  action_item only: :index do
    link_to "Import Members", new_member_imports_path
  end

  sidebar :Download, only: :index do
    ul do
      li link_to "All Members", members_path(format: "xls", shikaku: "all")
      li link_to "All Kyouju-sha", members_path(format: "xls", shikaku: "kyouju")
      li link_to "All Koushi ", members_path(format: "xls", shikaku: "koushi")
      li link_to "All Ippan Members", members_path(format: "xls", shikaku: "ippan")
      li link_to "All Kojin", members_path(format: "xls", shikaku: "kojin")

    end

  end

  sidebar :Labels, only: :index do
    ul do
      li link_to "All Members Lables", labels_path(shikaku: "all")
      li link_to "All Kyouju-sha Lables", labels_path(shikaku: "kyouju")
      li link_to "All Koushi Lables", labels_path(shikaku: "koushi")
      li link_to "All Ippan Lables", labels_path(shikaku: "ippan")
    end
  end

  sidebar :Books, only: :index do
    ul do
      li link_to "Domonkai Book", books_path(format: "pdf")
    end
  end

end
