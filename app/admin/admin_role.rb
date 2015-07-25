#ActiveAdmin.setup do |config|
#  config.download_links = false
#end

ActiveAdmin.register AdminRole do
  permit_params :role
  menu priority: 5, label: "Admin Role", :parent => "Admin"
  permit_params :role

  index do
    selectable_column
    id_column
    column :email
    column :role
    actions
  end

  form do |f|
    f.inputs "Admin Details" do
      f.input :email,  :input_html => {:disabled => true}
      f.input :role,  :as => :select, :collection => ['membership','dougu','super'] ,:include_blank => true
    end
    f.actions
  end

end
