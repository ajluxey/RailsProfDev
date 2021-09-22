import consumer from "../../channels/consumer";

document.addEventListener('turbolinks:load', () => {
  var questionsDOM = document.querySelector('.questions')
  if (questionsDOM){
    var questionsListDOM = questionsDOM.querySelector('.questions-list')
    if (questionsListDOM) {
      consumer.subscriptions.create("QuestionsChannel", {
        connected() {
        },

        disconnected() {
        },

        received(data) {
          questionsListDOM.insertAdjacentHTML('beforeend', data)
        }
      })
    }
  }
})
