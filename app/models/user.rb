class User < ApplicationRecord
  has_many :questions, foreign_key: :author_id, dependent: :destroy
  has_many :answers, foreign_key: :author_id, dependent: :destroy
  has_many :rewards, foreign_key: :respondent_id, dependent: :nullify
  has_many :ratings, class_name: 'UserRating', dependent: :destroy
  has_many :comments, foreign_key: :author_id, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def author?(resource)
    id == resource.author_id
  end

  def subscribed_on?(question)
    subscriptions.where(question: question).present?
  end

  # def subscription_on(question)
  #   @subscription_on ||= {}
  #   return @subscription_on[question.id] if @subscription_on.has_key?(question.id)
  #
  #   @subscription_on[question.id] = subscriptions.where(question: question).first
  # end
end
