class Answer < ApplicationRecord
  default_scope { order(best: :desc, updated_at: :desc) }

  include Rateable
  include Linkable
  include Commentable

  belongs_to :question
  belongs_to :author, class_name: 'User'

  has_many_attached :files


  validates :body, presence: true
  validates :best, inclusion: { in: [true, false] }
  validate  :validation_one_best_answer

  def is_best!
    previous_best_answer = question.best_answer
    begin
      Answer.transaction do
        previous_best_answer.not_best! if previous_best_answer.present?
        update!(best: true)
      end
    rescue ActiveRecord::RecordInvalid
      false
    else
      previous_best_answer
    end
  end

  def not_best!
    update!(best: false)
  end

  private

  def validation_one_best_answer
    if best? && question.answers.where(best: true).count > 0 && question.answers.where(best: true).first != self
      errors.add(:question, 'already have best answer')
    end
  end
end
