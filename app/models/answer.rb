class Answer < ApplicationRecord
  default_scope { order(best: :desc, updated_at: :desc) }

  belongs_to :question
  belongs_to :author, class_name: 'User'

  validates :body, presence: true
  validates :best, inclusion: { in: [true, false] }
  validate  :validation_one_best_answer

  def is_best!
    previous_best = question.remove_best_answer
    self.best = true
    save

    previous_best
  end

  def not_best!
    self.best = false
    save
  end

  private

  def validation_one_best_answer
    errors.add(:question, 'already have best answer') if best == true && question.answers.where(best: true).count > 1
  end
end
