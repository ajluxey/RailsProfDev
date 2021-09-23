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

    can :update_best, Answer do |answer|
      @user.author? answer.question
    end

    # Rateable resource
    can :rate,          [Answer, Question]
    can :rate_against,  [Answer, Question]
    can :cancel_rating, [Answer, Question]

    # Commentable resource
    can :new_comment, [Answer, Question]
  end

  def guest_abilities
    can :read, :all
  end
end
