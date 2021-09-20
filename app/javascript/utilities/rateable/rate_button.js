export default class RateButton {
  constructor(formDOM) {
    console.log(formDOM)
    this.formDOM = formDOM
    this.button = this.findButton()
  }

  findButton () {
    return this.formDOM.querySelector('input[type=submit]')
  }

  toggleVisible () {
    this.formDOM.classList.toggle('hidden')
  }
}
