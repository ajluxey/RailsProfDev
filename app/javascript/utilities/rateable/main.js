import Rating from "./rating";

document.addEventListener('turbolinks:load', () => {
  var ratings = document.querySelectorAll('.rating')
  if (ratings) ratings.forEach((ratingDiv) => {
    new Rating(ratingDiv)
  })
})
