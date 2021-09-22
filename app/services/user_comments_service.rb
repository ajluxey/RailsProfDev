class UserCommentsService
  def self.from(user)
    new(user)
  end

  def initialize(user)
    @user = user
  end

  def for(commentable_resource)
    @commentable_resource = commentable_resource
    self
  end

  def new_comment(comment_params)
    comment_params.merge!({ commentable: @commentable_resource })
    comment = @user.comments.new(comment_params)
    comment.save
    comment
  end

  def publish(comment)
    ActionCable.server.broadcast(
      'comments_channel',
      comment: ApplicationController.render(
        partial: 'comments/comment',
        locals: { comment: comment }
      ),
      for: { type: @commentable_resource.model_name.to_s.underscore,
             id: @commentable_resource.id }
    )
  end
end
