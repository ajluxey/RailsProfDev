class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :role

  def role
    object.admin? ? "admin" : "user"
  end
end
