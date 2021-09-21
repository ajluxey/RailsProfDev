module Commented
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!, only: :new_comment
    before_action :set_commentable, only: :new_comment
  end

  # TODO clear comment form
  def new_comment
    comment = UserCommentsService.from(current_user).for(@commentable).new_comment(comment_params)
    ActionCable.server.broadcast(
      'comments_channel',
      comment: ApplicationController.render(
        partial: 'comments/comment',
        locals: { comment: comment }
      ),
      for: { type: @commentable.model_name.to_s.underscore,
             id: @commentable.id }
    )
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