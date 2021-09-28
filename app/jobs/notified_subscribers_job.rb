class NotifiedSubscribersJob < ApplicationJob
  queue_as :mailer

  def perform(answer)
    NotificationService.notify_about_new_answer(answer)
  end
end
