import AnswersList from "./answers_list";

document.addEventListener('turbolinks:load', () => {
  const answersDOM = document.querySelector('div.answers')

  const answersList = new AnswersList(answersDOM)
})
