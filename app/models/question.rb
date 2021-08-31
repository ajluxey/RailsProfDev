class Question < ApplicationRecord
  belongs_to :author, class_name: 'User'
  has_many :answers, dependent: :destroy

  validates :title, :body, presence: true

  def remove_best_answer
    if answers.where(best: true).count > 0
      answer = answers.where(best: true).first
      answer.not_best!

      answer
    end
  end
end
