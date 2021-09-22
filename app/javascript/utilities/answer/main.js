import AnswersList from "./answers_list";
import consumer from "../../channels/consumer";
import Answer from "./answer";

document.addEventListener('turbolinks:load', () => {
  const answersDOM = document.querySelector('div.answers')

  if (answersDOM) {
    var answerList = new AnswersList(answersDOM)

    consumer.subscriptions.create({
      channel: "AnswersChannel",
      question_id: answersDOM.dataset.questionId
    }, {
      connected() {
      },

      disconnected() {
      },

      received(data) {
        console.log(data)
      }
    })
  }
})
