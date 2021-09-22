import consumer from "../../channels/consumer";
import CommentForm from "./comment_form";


document.addEventListener('turbolinks:load', () => {
  var commentsDOM = document.querySelectorAll('.comments')
  if (commentsDOM) {
    commentsDOM.forEach((commentDOM) => {
      var commentForm = commentDOM.querySelector('form')
      if (commentForm){
        new CommentForm(commentForm)
      }
    })

    consumer.subscriptions.create("CommentsChannel", {
      connected() {
      },

      disconnected() {
      },

      received(data) {
        let commentableDOM = this.findCommentable(data.for)
        commentableDOM.querySelector('.comments-list').insertAdjacentHTML('beforeend', data.comment)
      },

      findCommentable(data) {
        const dataAttribute = `[data-${data.type.replace('_', '-')}-id="${data.id}"]`
        const commentableDOM = document.querySelector(dataAttribute)

        return commentableDOM
      }
    })
  }
})
