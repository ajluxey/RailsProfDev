import AnswerUpdateForm from "./answer_update_form";

document.addEventListener('turbolinks:load', () => {
  const createForm = document.querySelector('form.create-answer')
  let updateForms = document.querySelectorAll(`form[data-answer-id]`)
  let updateFormsMap = new Map()

  updateForms.forEach((form) => {
    updateFormsMap.set(form.dataset.answerId, new AnswerUpdateForm(form))
  })

  if (createForm) createForm.addEventListener('ajax:success', (event) => {
    let updateForms = document.querySelectorAll(`form[data-answer-id]`)

    updateForms.forEach((form) => {
      if (!updateFormsMap.has(form.dataset.answerId)) new AnswerUpdateForm(form)
    })
  })
})



