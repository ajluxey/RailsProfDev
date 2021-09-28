class NotificationMailer < ApplicationMailer
  def new_answer(user, answer)
    @greeting = "Hi"
    @answer = answer

    mail to: user
  end
end
