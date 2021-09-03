class Question < ApplicationRecord
  belongs_to :author, class_name: 'User'
  has_many :answers, dependent: :destroy

  has_many_attached :files

  validates :title, :body, presence: true

  def best_answer
    best_answer_scope = answers.where(best: true)
    best_answer_scope.first if best_answer_scope.count.positive?
  end
end
