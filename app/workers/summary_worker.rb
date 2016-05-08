class SummaryWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  sidekiq_options queue: "default", retry: false

  schedule_time_zone 'Central Time (US & Canada)'

  recurrence do
    daily(1).hour_of_day(20)
  end

  def perform
    existing_summary_helper_ids = Summary.all.map(&:helper_id)
    Connection.accepted.where.not(user_id: existing_summary_helper_ids).each do |connection|
      next unless connection.dream
      SummaryMailer.write_summary(connection.dream.user.id, connection.dream.id, connection.user.id).deliver
    end
  end
end