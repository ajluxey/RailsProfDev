export default class CommentForm {
  constructor (formDOM) {
    this.formDOM = formDOM
    this.input = formDOM.querySelector('input[type="text"]')
    this.errorsWindow = formDOM.parentNode.querySelector('.comment-errors')

    this.formDOM.addEventListener('ajax:success', this.ajaxHandler.bind(this))
  }

  ajaxHandler (event) {
    if (event.detail[0].hasOwnProperty("errors")) {
      this.showErrors(event.detail[0].errors)
    } else {
      this.clearForm()
    }
  }

  clearForm () {
    this.input.value = ''
    this.errorsWindow.innerHTML = ''
  }

  showErrors (errors) {
    this.errorsWindow.append(errors)
  }
}
