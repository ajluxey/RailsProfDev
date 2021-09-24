class FileSerializer < ActiveModel::Serializer
  attributes :id, :name, :url

  def name
    object.filename.to_s
  end
end
