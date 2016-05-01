class MailerWorker
  include Sidekiq::Worker
  sidekiq_options queue: "mailer", retry: false, backtrace: true
  
  def perform(name, count)
    # do something
  end
end