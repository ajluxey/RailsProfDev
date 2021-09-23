class User < ApplicationRecord
  has_many :questions, foreign_key: :author_id, dependent: :destroy
  has_many :answers, foreign_key: :author_id, dependent: :destroy
  has_many :rewards, foreign_key: :respondent_id, dependent: :nullify
  has_many :ratings, class_name: 'UserRating', dependent: :destroy
  has_many :comments, foreign_key: :author_id, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def author?(resource)
    id == resource.author_id
  end
end
