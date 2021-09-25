class QuestionsSerializer < ActiveModel::Serializer
  attributes :id, :title, :body

  belongs_to :author
end
