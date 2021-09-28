class DailyMailer < ApplicationMailer
  def digest(user, questions)
    @greeting = "Hi"
    @questions = questions

    mail to: user.email
  end
end
