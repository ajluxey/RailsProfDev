export default class AnswerUpdateForm {
  constructor(form) {
    this.form = form
    this.dataId = form.dataset.answerId
    this.editLink =  document.querySelector(`.edit-answer-link[data-answer-id="${this.dataId}"]`)
    this.closeLink = this.createCloseLink()

    this.form.addEventListener('ajax:success', this.update.bind(this))

    this.linksBehavior()
  }

  update () {
    const updatedForm = document.querySelector(`form.update-answer[data-answer-id="${this.dataId}"]`)
    this.constructor(updatedForm)
  }

  createCloseLink () {
    let link = document.createElement('a')
    link.href = '#'
    link.text = 'Close'
    link.class = 'close-edit-answer-link'
    link.dataset.answerId = this.dataId
    this.form.append(link)

    return link
  }

  linksBehavior () {
    this.editLink.addEventListener('click', (event) => {
      event.preventDefault()

      $(this.editLink).hide()
      $(this.form).show()
    })

    this.closeLink.addEventListener('click', (event) => {
      event.preventDefault()

      $(this.editLink).show()
      $(this.form).hide()
    })
  }
}