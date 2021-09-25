# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user
    if user
      user_abilities
    else
      guest_abilities
    end
  end

  def user_abilities
    can :read,    :all
    can :create,  [Question, Answer, Comment]
    can :update,  [Question, Answer], author_id: @user.id
    can :destroy, [Question, Answer], author_id: @user.id

    # Question subscribes
    can :subscribe_on, Question do |question|
      !@user.subscribed_on?(question)
    end

    can :unsubscribe_from, Question do |question|
      @user.subscribed_on?(question)
    end

    # Answer
    can :update_best, Answer do |answer|
      @user.author? answer.question
    end

    # Rateable resource
    alias_action :rate, :rate_against, to: :rates
    can :rates, [Answer, Question] do |rateable|
      rateable.author_id != @user.id && !UserRating.where(user: @user, rateable: rateable).present?
    end
    can :cancel_rating, [Answer, Question] do |rateable|
      UserRating.where(user: @user, rateable: rateable).present?
    end

    # Commentable resource
    can :new_comment, [Answer, Question]
  end

  def guest_abilities
    can :read, :all
  end
end
