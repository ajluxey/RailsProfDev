module Rateable
  extend ActiveSupport::Concern

  included do
    has_many :user_marks, as: :rateable, class_name: 'UserRating', dependent: :destroy
  end

  def rating
    likes = user_marks.where(mark: true).count
    dislikes = user_marks.where(mark: false).count

    likes - dislikes
  end

  def rated_by?(user)
    user_marks.where(user: user).present?
  end

  def data_attribute_id
    { id: id, resource: model_name.to_s }
  end
end
