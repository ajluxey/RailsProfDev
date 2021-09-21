import AnswersList from "./answers_list";
import consumer from "../../channels/consumer";

document.addEventListener('turbolinks:load', () => {
  const answersDOM = document.querySelector('div.answers')

  if (answersDOM) {
    var answerList = new AnswersList(answersDOM)

    consumer.subscriptions.create({
      channel: "AnswersChannel",
      question_id: answersDOM.dataset.questionId
    }, {
      connected() {
        console.log("Connected to AnswerChannel question " + answersDOM.dataset.questionId )
      },

      disconnected() {
        console.log("Disconnected from AnswerChannel question " + answersDOM.dataset.questionId )
      },

      received(data) {
        console.log(data)
      }
    })
  }
})
