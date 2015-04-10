ActiveAdmin.register User do


  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if resource.something?
  #   permitted
  # end
  permit_params(
    :email,
    :created_at,
    :updated_at,
    :first_name,
    :last_name,
    :provider,
    :uid,
    :name,
    :timezone,
    :gender,
    :facebook_image,
    :username,
    :premium,
    :upgrade_date,
    :stripe_cus_id,
    :phone_number,
    :admin
  )

  ActiveAdmin.register User do
    index :as => ActiveAdmin::Views::IndexAsTable do
      column "ID" do |user|
        link_to user.id, admin_user_path(user)
      end
      column :email
      column :first_name
      column :last_name
      column :gender
      actions
    end
  end

  filter :email
  filter :first_name
  filter :last_name
end
