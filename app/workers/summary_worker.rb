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
    if ENV["AUTO_SUMMARY_EMAILS"] == "true"
      Connection.accepted.where.not(user_id: existing_summary_helper_ids).each do |connection|
        next unless connection.dream
        if connection.updated_at.to_date + 1.week == Time.current.to_date || connection.updated_at.to_date + 2.weeks == Time.current.to_date || connection.updated_at.to_date + 3.week == Time.current.to_date
          SummaryMailer.write_summary(connection.dream.user.id, connection.dream.id, connection.user.id).deliver
        end
      end
    end
  end
end