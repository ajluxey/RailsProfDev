class User < ApplicationRecord
  has_many :questions, foreign_key: :author_id, dependent: :destroy
  has_many :answers, foreign_key: :author_id, dependent: :destroy
  has_many :rewards, foreign_key: :respondent_id, dependent: :nullify
  has_many :ratings, class_name: 'UserRating', dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def author?(resource)
    id == resource.author_id
  end

  def can_change_rating?(resource)
    !author?(resource)
  end

  def rates(resource)
    rates!(resource, true)
  end

  def rates_against(resource)
    rates!(resource, false)
  end

  def cancel_rating_for(resource)
    return false unless can_change_rating?(resource)

    ratings.for(resource).first.destroy!
  rescue ActiveRecord::ActiveRecordError, NoMethodError
    false
  else
    true
  end

  private

  def rates!(resource, mark)
    return false unless can_change_rating?(resource)

    ratings.create!(rateable: resource, mark: mark)
  rescue ActiveRecord::ActiveRecordError
    false
  else
    true
  end
end
