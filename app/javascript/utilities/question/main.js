import QuestionUpdateForm from "./question_update_form";

document.addEventListener('turbolinks:load', () => {
  const questionDOM = document.querySelector('div.question')
  if (questionDOM) {
    const formDOM = questionDOM.querySelector('form.update-question')
    if (formDOM) {
      let questionUpdateForm = new QuestionUpdateForm(formDOM)
    }
  }
})
