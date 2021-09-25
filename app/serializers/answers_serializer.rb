class AnswersSerializer < ActiveModel::Serializer
  attributes :id, :body, :best

  belongs_to :author
end
