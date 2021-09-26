module SubscriptionsHelper
  def subscription_buttons_for(question)
    return content_tag(:i, 'You are not authorized to subscribe') unless can?(:subscribe_on, question) || can?(:unsubscribe_from, question)

    subscription = current_user.subscriptions.where(question: question).first
    if subscription.present?
      message = "You are subscribed on this question. Want to unsubscribe?"
      button = button_to('Unsubscribe', subscription_path(subscription), method: :delete, remote: true)
    else
      message = "This question doesn't have answer for you? You can subscribe to be notified of new answers"
      button = button_to('Subscribe', question_subscriptions_path(question), method: :post, remote: true)
    end
    content_tag(:i, message, class: 'subscription-message') + button
  end
end
