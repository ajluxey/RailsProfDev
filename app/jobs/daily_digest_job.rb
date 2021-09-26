class DailyDigestJob < ApplicationJob
  queue_as :default

  def perform
    NotificationService.send_daily_digest
  end
end
