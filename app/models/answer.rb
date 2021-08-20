class Answer < ApplicationRecord
  belongs_to :question

  validates :body,    presence: true
  validates :correct, inclusion: { in: [true, false] }
end
