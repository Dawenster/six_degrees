task :make_messages_from_connections => :environment do |t, args|
  Connection.all.each do |connection|
    next unless connection.dream.user
    puts connection.initial_message
    Message.create(
      :content => connection.initial_message,
      :dream_id => connection.dream_id,
      :user_id => connection.user_id,
      :recipient_id => connection.dream.user.id
    )
  end
end