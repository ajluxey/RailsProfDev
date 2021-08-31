import AnswerUpdateForm from "./answer_update_form";
import Answer from "./answer";
import AnswersList from "./answers_list";

document.addEventListener('turbolinks:load', () => {
  // const createForm = document.querySelector('form.create-answer')
  const answersDOM = document.querySelector('div.answers')

  const answersList = new AnswersList(answersDOM)
})

  // if (createForm) createForm.addEventListener('ajax:success', (event) => {
  //   answersList.loadAnswers()
  // })


  // let updateForms = document.querySelectorAll(`form[data-answer-id]`)
  // let updateFormsMap = new Map()
  //
  // updateForms.forEach((form) => {
  //   updateFormsMap.set(form.dataset.answerId, new AnswerUpdateForm(form))
  // })
  //
  // if (createForm) createForm.addEventListener('ajax:success', (event) => {
  //   let updateForms = document.querySelectorAll(`form[data-answer-id]`)
  //
  //   updateForms.forEach((form) => {
  //     if (!updateFormsMap.has(form.dataset.answerId)) {
  //       updateFormsMap.set(form.dataset.answerId, new AnswerUpdateForm(form))
  //     }
  //   })
  // })
