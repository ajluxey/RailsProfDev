class SubscriptionsController < ApplicationController
  def create
    @question = Question.find(params[:question_id])

    SubscriberService.new(current_user).subscribe_on(@question)
    flash.now[:notice] = 'You are subscribed'
  end

  def destroy
    @subscription = Subscription.find(params[:id])
    SubscriberService.new(current_user).unsubscribe(@subscription)
    flash.now[:notice] = 'You are unsubscribed'
  end
end
