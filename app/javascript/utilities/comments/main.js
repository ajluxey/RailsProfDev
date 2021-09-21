import consumer from "../../channels/consumer";


document.addEventListener('turbolinks:load', () => {
  const questionDOM = document.querySelector('div.question')
  if (questionDOM) {
    consumer.subscriptions.create("CommentsChannel", {
      connected() {
        console.log('Connected to Comments channel')
      },

      disconnected() {
        console.log('Disconnected from Comments channel')
      },

      received(data) {
        let commentableDOM = this.findCommentable(data.for)
        commentableDOM.querySelector('.comments')
        commentableDOM.html()
      },

      findCommentable(data) {
        const dataAttribute = '[data-' + data.type.replace('_', '-') + '-id]'
        const commentableDOM = document.querySelector(dataAttribute)

        return commentableDOM
      }
    })
  }
})
