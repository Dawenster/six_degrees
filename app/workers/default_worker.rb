class DefaultWorker
  include Sidekiq::Worker
  sidekiq_options queue: "default", retry: false, backtrace: true
  
  def perform(name, count)
    # do something
  end
end