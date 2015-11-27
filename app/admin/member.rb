#encoding: utf-8
ActiveAdmin.register Member do
  # allow these params to be updated
  permit_params :domonkai_id, :first_name, :last_name,
                :japanese_first_name, :japanese_last_name, :tea_name, :japanese_tea_name,
                :email, :sex, :address, :city, :state, :zip, :country, :phone, :fax , :sensei_member_id,
                :shikaku_kubun_id, :record_updated, :language, :yakuin


  menu priority: 4, :parent => "Membership"

  #config.per_page = 30
  config.paginate = false
  #index :download_links => [:csv, :xlsx]

  sidebar :Download do
    ul do
      li link_to "All Members", members_path(format: "xls", shikaku: "all")
      li link_to "All Kyouju-sha", members_path(format: "xls", shikaku: "kyouju")
      li link_to "All Shikaku-sha ", members_path(format: "xls", shikaku: "shikaku")
      li link_to "All Ippan Members", members_path(format: "xls", shikaku: "ippan")
      li link_to "All Kojin", members_path(format: "xls", shikaku: "kojin")
    end
  end
  sidebar :Labels, only: :index do
    ul do
      li link_to "All Members Lables", labels_path(shikaku: "all")
      li link_to "All Kyouju-sha Lables", labels_path(shikaku: "kyouju")
      li link_to "All Shikaku-sha Lables", labels_path(shikaku: "shikaku")
      li link_to "All Ippan Lables", labels_path(shikaku: "ippan")
      li link_to "All Kojin Lables", labels_path(shikaku: "kojin")
      li link_to "Members with no emails", labels_path(shikaku: "no_email")
    end
  end

  sidebar :Books, only: :index do
    ul do
      li link_to "Domonkai Book", books_path(format: "pdf")
    end
  end
  #actions :all, :except => [:new, :create, :destroy]

  #menu :parent => "Member"

  # default sort column
  config.sort_order = :domonkai_id




  # displays the site_id but uses site_info_id for the query
  filter :shikaku_kubun_id, :as => :select, :collection => ShikakuKubun.all.collect {|s| [s.name, s.id]}, :label => Constants::SHIKAKU_LABEL
  filter :sensei_member_id, :as => :select, :collection => Member.where(shikaku_kubun_id:  [1,2]).order(:last_name).collect {|m| [m.last_name+ ' ' +m.first_name, m.id]} , :label => Constants::SHACHU_LABEL
  filter :first_name
  filter :last_name
  filter :domonkai_id, :label => Constants::DOMONKAI_ID_LABEL
  filter :record_updated
  filter :yakuin

  controller do
    def scoped_collection
      super.includes :shikaku_kubun  # prevents N+1 queries to your database
    end
  end

  index do

    selectable_column
    column Constants::DOMONKAI_ID_LABEL, sortable: 'domonkai_id' do |member|
       member.domonkai_id.to_i
    end
    column Constants::SHACHU_LABEL, sortable: 'sensei_member_id'  do |member|
      unless member.shachu.nil?
        member.shachu.last_name + ' '+  member.shachu.first_name

      else
        member.shachu
      end

    end

    column Constants::SHIKAKU_LABEL , sortable: 'shikaku_kubuns.name' do |member|
      member.shikaku_kubun_name
    end
    column Constants::NAME_LABEL , sortable: 'last_name' do |member|
      member.first_name.to_s + ' ' + member.last_name.to_s
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
      f.input :sex, :as => :select, :collection => ['Male', 'Female', 'N/A'], :include_blank => false
      f.input :address
      f.input :city
      f.input :state
      f.input :zip
      f.input :country , :as => :string
      f.input :phone
      f.input :fax
      f.input :sensei_member_id, :include_blank => true, :as => :select, :collection => Member.where(shikaku_kubun_id: [1,2]).order(:last_name).collect {|m| [m.last_name + ' '+  m.first_name, m.id]} , :label => Constants::SHACHU_LABEL
      f.input :shikaku_kubun_id, :include_blank => false, :as => :select, :collection => ShikakuKubun.all.collect {|m| [m.name, m.id]} , :label => Constants::SHIKAKU_LABEL
      f.input :language
      f.input :record_updated
      f.input :yakuin
    end
    f.actions
  end

  show do |member|
    attributes_table do
      row :domonkai_id ,  :label => Constants::DOMONKAI_ID_LABEL
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
      row Constants::SHACHU_LABEL do
        unless member.shachu.nil?
          member.shachu.last_name + ' ' + member.shachu.first_name
        else
          member.shachu
        end
      end

      row Constants::SHIKAKU_LABEL do
        member.shikaku_kubun.name
      end
      row :language
      row :record_updated
      row :yakuin
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

  action_item only: :index do
    link_to "Import Members", new_member_imports_path
  end

  batch_action :edit_members, form: {
                                RECORD_UPDATED: %w[true false]
                            } do |selection, inputs|

    puts inputs[:record_updated]
    Member.where(:id => selection).update_all(record_updated: inputs[:RECORD_UPDATED]) # ':id => selection' same as 'id in (selection)'
    redirect_to collection_path, notice: "States of selected members have been successfully modified!"


  end


end