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

  def related_resource_as_json
    related_resource = {}
    if files.present?
      related_resource['files'] = []

      files.each do |file|
        related_resource['files'] << { file.filename.to_s => url_for(file) }
      end
    end

    if links.present?
      related_resource['links'] = []

      links.each do |link|
        related_resource['links'] << { link.name => link.url }
      end
    end
  end

  private

  def validation_one_best_answer
    if best? && question.answers.where(best: true).count > 0 && question.answers.where(best: true).first != self
      errors.add(:question, 'already have best answer')
    end
  end
end
