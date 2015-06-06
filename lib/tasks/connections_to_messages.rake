task :make_messages_from_connections => :environment do |t, args|
  Connection.all.each do |connection|
    puts connection.initial_message
    Message.create(
      :content => connection.initial_message,
      :dream_id => connection.dream_id,
      :user_id => connection.user_id
    )
  end
end