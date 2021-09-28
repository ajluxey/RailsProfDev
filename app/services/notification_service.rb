class NotificationService
  def self.send_daily_digest
    questions = Question.where('created_at > ?', 24.hours.ago).to_a

    User.find_each do |user|
      DailyMailer.digest(user, questions).deliver_later
    end
  end

  def self.notify_about_new_answer(answer)
    answer.question.subscribers.each do |subscriber|
      NotificationMailer.new_answer(subscriber, answer).deliver_later
    end
  end
end