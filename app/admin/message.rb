ActiveAdmin.register Message do
  permit_params do
    permitted = [
      :content,
      :dream_id,
      :user_id,
      :recipient_id
    ]
    # permitted << :other if resource.something?
    permitted
  end

  index :as => ActiveAdmin::Views::IndexAsTable do
    column "ID" do |user|
      link_to user.id, admin_user_path(user)
    end
    column :content
    column "Sender" do |message|
      link_to message.user.full_name, admin_user_path(message.user)
    end
    column "Recipient" do |message|
      link_to message.recipient.full_name, admin_user_path(message.recipient)
    end
    column :created_at
    column :updated_at
    actions
  end
end
