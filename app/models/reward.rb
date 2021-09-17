class Reward < ApplicationRecord
  belongs_to :question
  belongs_to :respondent, class_name: 'User', optional: true

  has_one_attached :image

  validates :name, presence: true
  validates :image, attached: true, content_type: %i[png jpeg]
end
