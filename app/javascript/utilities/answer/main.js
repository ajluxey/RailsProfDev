import AnswersList from "./answers_list";

document.addEventListener('turbolinks:load', () => {
  const answersDOM = document.querySelector('div.answers')

  if (answersDOM) new AnswersList(answersDOM)
})
