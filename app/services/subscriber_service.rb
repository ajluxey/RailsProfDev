class SubscriberService
  def initialize(user)
    @user = user
  end

  def subscribe_on(question)
    raise CanCan::AccessDenied.new('Not authorized!', :subscribe_on, question) if Ability.new(@user).cannot? :subscribe_on, question

    @user.subscriptions.create!(question: question)
  end

  def unsubscribe(subscription)
    question = subscription.question

    raise CanCan::AccessDenied.new('Not authorized!', :unsubscribe_from, question) if Ability.new(@user).cannot? :unsubscribe_from, question

    subscription.destroy
  end
end