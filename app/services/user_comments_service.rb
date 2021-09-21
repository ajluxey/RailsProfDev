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
    @user.comments.create!(comment_params)
  end
end