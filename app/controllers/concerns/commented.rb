module Commented
  extend ActiveSupport::Concern

  included do
    before_action :set_commentable, only: :new_comment
  end

  def new_comment
    comment_service = UserCommentsService.from(current_user).for(@commentable)
    comment = comment_service.new_comment(comment_params)
    if comment.errors.any?
      respond_to do |format|
        format.json { render json: { errors: comment.errors.full_messages } }
      end
    else
      comment_service.publish(comment)
    end
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