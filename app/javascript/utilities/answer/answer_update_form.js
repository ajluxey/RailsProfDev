export default class AnswerUpdateForm {
  constructor(form) {
    this.form = form
    this.dataId = form.dataset.answerId
    this.editLink =  this.form.parentNode.querySelector(`.edit-answer-link[data-answer-id="${this.dataId}"]`)
    this.closeLink = this.setCloseLink()

    this.linksBehavior()
  }

  setCloseLink () {
    let closeLink = this.form.querySelector(`a.close-edit-answer-link[data-answer-id="${this.dataId}"]`)
    if (!closeLink) closeLink = this.createCloseLink()
    return closeLink
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
