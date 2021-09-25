class Question < ApplicationRecord
  include Rateable
  include Linkable
  include Commentable

  belongs_to :author, class_name: 'User'
  has_many   :answers, dependent: :destroy
  has_one    :reward, dependent: :destroy
  has_many   :subscriptions, dependent: :destroy
  has_many   :subscribers, through: :subscriptions, source: :user

  has_many_attached :files

  accepts_nested_attributes_for :reward, reject_if: :all_blank

  validates :title, :body, presence: true

  def best_answer
    best_answer_scope = answers.where(best: true)
    best_answer_scope.first if best_answer_scope.count.positive?
  end
end
