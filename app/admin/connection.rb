ActiveAdmin.register Connection do


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
  index :as => ActiveAdmin::Views::IndexAsTable do
    column "ID" do |connection|
      link_to connection.id, admin_connection_path(connection)
    end
    column :initial_message
    column "Dream" do |connection|
      link_to connection.dream.description, admin_dream_path(connection.dream)
    end
    column "Helper" do |connection|
      if connection.user.nil?
        "N/A"
      else
        link_to connection.user.full_name, admin_user_path(connection.user)
      end
    end
    column "Receiver" do |connection|
      if connection.dream.user.nil?
        "N/A"
      else
        link_to connection.dream.user.full_name, admin_user_path(connection.dream.user)
      end
    end
    column :accepted
    column :created_at
    actions
  end
end
