class SubscriptionsController < ApplicationController
  def create
    @question = Question.find(params[:question_id])

    authorize! :subscribe_on, @question

    current_user.subscriptions.create(question: @question)
    flash.now[:notice] = 'You are subscribed'
  end

  def destroy
    @subscription = Subscription.find(params[:id])
    @question = @subscription.question

    authorize! :unsubscribe_from, @question

    @subscription.destroy
    flash.now[:notice] = 'You are unsubscribed'
  end
end
