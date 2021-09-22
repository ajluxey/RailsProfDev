class AnswersChannel < ApplicationCable::Channel
  def subscribed
    question = Question.find(params[:question_id])
    stream_for question
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
