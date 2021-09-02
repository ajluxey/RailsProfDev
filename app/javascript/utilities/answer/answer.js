import AnswerUpdateForm from "./answer_update_form";

export default class Answer {
  constructor(answer, answerList) {
    this.answers = answerList
    this.DOM = answer
    this.id = answer.dataset.answerId
    this.answerUpdateForm = this.findAnswerUpdateForm()
  }

  addBestLabel () {
    let bestLabel = document.createElement('i')
    bestLabel.innerHTML = 'Best answer'
    this.DOM.prepend(bestLabel)
  }

  removeBestLabel () {
    let bestLabel = this.DOM.querySelector('i')
    if (bestLabel) bestLabel.remove()
  }

  removeHighlightButton () {
    let button = this.DOM.querySelector('form.button_to')
    button.remove()
  }

  findAnswerUpdateForm () {
    const form = this.DOM.querySelector(`form[data-answer-id="${this.id}"]`)
    let formClass = null
    if (form) formClass = new AnswerUpdateForm(form)
    return formClass
  }

  findHighLightForm () {
    const form = this.DOM.querySelector(`form.button_to`)

    if (form) {
      form.addEventListener('ajax:success', this.bestUpdate.bind(this))
    }
    return form
  }

  bestUpdate () {
    this.answers.highlightAnswer(this)
  }
}
