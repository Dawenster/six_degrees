ActiveAdmin.register Dream do
  index :as => ActiveAdmin::Views::IndexAsTable do
    column "ID" do |connection|
      link_to connection.id, admin_connection_path(connection)
    end
    column :description
    column :dream_type
    column "User" do |dream|
      if dream.user.nil?
        "N/A"
      else
        link_to dream.user.full_name, admin_user_path(dream.user)
      end
    end
    column "Connections received" do |dream|
      dream.connections.count
    end
    column "Connections approved" do |dream|
      dream.num_approved
    end
    column "Connections declined" do |dream|
      dream.num_declined
    end
    column :created_at
    actions
  end

  filter :user, :collection => proc { User.all.sort_by{|u|u.full_name} }
  filter :description
  filter :dream_type
end
