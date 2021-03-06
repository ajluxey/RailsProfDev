export default class QuestionUpdateForm {
  constructor(formDOM) {
    this.DOM = formDOM
    this.editLink =  this.DOM.parentNode.querySelector('.edit-question-link')
    this.closeLink = this.setCloseLink()

    this.behaviour()
  }

  setCloseLink () {
    let closeLink = this.DOM.querySelector('a.close-edit-question-link')
    if (!closeLink) closeLink = this.createCloseLink()
    return closeLink
  }

  createCloseLink () {
    let link = document.createElement('a')
    link.href = '#'
    link.text = 'Close'
    link.class = 'close-edit-question-link'
    this.DOM.append(link)

    return link
  }

  behaviour() {
    this.DOM.addEventListener('ajax:success', () => {
      this.update()
    })

    this.linksBehavior()
  }

  linksBehavior () {
    this.editLink.addEventListener('click', (event) => {
      event.preventDefault()

      $(this.editLink).hide()
      $(this.DOM).show()
    })

    this.closeLink.addEventListener('click', (event) => {
      event.preventDefault()

      $(this.editLink).show()
      $(this.DOM).hide()
    })
  }

  update () {
    let updateFormDOM = document.querySelector('form.update-question')
    this.constructor(updateFormDOM)
  }
}
