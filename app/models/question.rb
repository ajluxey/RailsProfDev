class Question < ApplicationRecord
  belongs_to :author, class_name: 'User'
  has_many   :answers, dependent: :destroy
  has_many   :links, as: :linkable, dependent: :destroy

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :title, :body, presence: true

  def best_answer
    best_answer_scope = answers.where(best: true)
    best_answer_scope.first if best_answer_scope.count.positive?
  end
end
