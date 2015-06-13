ActiveAdmin.register Connection do
  index :as => ActiveAdmin::Views::IndexAsTable do
    column "ID" do |connection|
      link_to connection.id, admin_connection_path(connection)
    end
    column "Dream" do |connection|
      if connection.dream
        link_to connection.dream.description, admin_dream_path(connection.dream)
      else
        "N/A"
      end
    end
    column "Helper" do |connection|
      if connection.user.nil?
        "N/A"
      else
        link_to connection.user.full_name, admin_user_path(connection.user)
      end
    end
    column "Receiver" do |connection|
      if connection.dream
        if connection.receiver.nil?
          "N/A"
        else
          link_to connection.receiver.full_name, admin_user_path(connection.receiver)
        end
      else
        "N/A"
      end
    end
    column :accepted
    column :created_at
    actions
  end

  preserve_default_filters!
  filter :user, :collection => proc { User.all.sort_by{|u|u.full_name} }, :label => "Helper"
  filter :dream, :collection => proc { Dream.all.map{|d|d.description}.sort }

  csv do
    column :id
    column("Dream") { |connection| connection.dream.nil? ? "N/A" : connection.dream.description }
    column("Helper name") { |connection| connection.user.nil? ? "N/A" : connection.user.full_name }
    column("Helper ID") { |connection| connection.user.nil? ? "N/A" : connection.user.id }
    column("Receiver name") { |connection| connection.dream && !connection.receiver.nil? ? connection.receiver.full_name : "N/A" }
    column("Receiver ID") { |connection| connection.dream && !connection.receiver.nil? ? connection.receiver.id : "N/A" }
    column :initial_message
    column :accepted
    column :created_at
    column :updated_at
  end
end
