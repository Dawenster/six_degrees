ActiveAdmin.register User do
  permit_params do
    permitted = [
      :email,
      :first_name,
      :last_name,
      :name,
      :gender,
      :admin
    ]
    # permitted << :other if resource.something?
    permitted
  end

  ActiveAdmin.register User do
    index :as => ActiveAdmin::Views::IndexAsTable do
      column "ID" do |user|
        link_to user.id, admin_user_path(user)
      end
      column :email
      column :first_name
      column :last_name
      column "Facebook ID", :uid
      column :gender
      column :admin
      actions
    end
  end

  form do |f|
    f.inputs "User" do
      f.input :email
      f.input :first_name
      f.input :last_name
      f.input :name
      f.input :gender
      f.input :admin
    end 
    f.actions
  end

  filter :email
  filter :first_name
  filter :last_name
end
