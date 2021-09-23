class RewardsController < ApplicationController
  before_action :authenticate_user!

  authorize_resource

  def index
  end
end
