class UserRating < ApplicationRecord
  belongs_to :user
  belongs_to :rateable, polymorphic: true

  validates :mark, inclusion:  { in: [true, false] }
  validates :user, uniqueness: { scope: :rateable  }

  validate :validate_author_can_not_rate

  scope :for, ->(resource) { where(rateable: resource) }

  private

  def validate_author_can_not_rate
    errors.add(:user, 'Author can not rate') if rateable.author == user
  end
end
