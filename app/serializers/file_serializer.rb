class FileSerializer < ActiveModel::Serializer
  attributes :id, :name, :url

  def name
    object.filename.to_s
  end

  # def url
  #   Rails.application.routes.url_for(object)
  # end
end
