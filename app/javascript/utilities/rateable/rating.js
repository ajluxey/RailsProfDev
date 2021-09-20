import RateButton from "./rate_button";

export default class Rating {
  constructor(div) {
    this.div = div
    this.ratingCounter = div.querySelector('.rating-counter')

    this.setButtons()
  }

  setButtons () {
    if (this.div.querySelectorAll('.update-rating').length == 0) return

    this.likeButton = new RateButton(this.div.querySelector('form.like.update-rating'))
    this.dislikeButton = new RateButton(this.div.querySelector('form.dislike.update-rating'))
    this.cancelButton = new RateButton(this.div.querySelector('form.cancel.update-rating'))

    this.setButtonsBehaviour()
  }

  setButtonsBehaviour () {
    const buttons = [this.likeButton, this.dislikeButton, this.cancelButton]
    buttons.forEach((button) =>{
      button.formDOM.addEventListener('ajax:success', this.ajaxSuccessHandler.bind(this))
    })
  }

  ajaxSuccessHandler (event) {
    const response = event.detail[0]
    this.ratingCounter.innerHTML = response.rating
    this.toggleVisibleOfButtons()
  }

  toggleVisibleOfButtons () {
    this.likeButton.toggleVisible()
    this.dislikeButton.toggleVisible()
    this.cancelButton.toggleVisible()
  }
}
