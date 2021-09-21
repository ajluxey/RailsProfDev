module Commented
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!, only: :new_comment
    before_action :set_commentable, only: :new_comment
  end

  def new_comment
    UserCommentsService.from(current_user).for(@commentable).new_comment(comment_params)
    # CommentsChannel.broadcast_to
    # подумать - "#{model_klass.pluralize}Channel"
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_commentable
    @commentable = model_klass.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end