class Api::V1::ProfilesController < Api::V1::BaseController
  def me
    render json: current_resource_owner
  end

  def other_users
    render json: User.all.where.not(id: current_resource_owner.id)
  end
end
