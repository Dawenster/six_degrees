class MailerWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :mailers, :retry => false, :backtrace => true
  
  def perform(name, count)
    # do something
  end
end