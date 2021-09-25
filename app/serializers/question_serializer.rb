class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :files

  has_many   :comments
  has_many   :links
  belongs_to :author

  def files
    object.files.map { |file| FileSerializer.new(file, scope: scope, root: false, event: object) }
  end
end
