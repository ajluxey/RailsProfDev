import Answer from "./answer";

export default class AnswersList {
  constructor(answersDOM) {
    this.DOM = answersDOM
    this.answersMap = new Map()
    this.loadAnswers()
  }

  loadAnswers () {
    for (let answerDOM of this.DOM.children) {
      let answerId = answerDOM.dataset.answerId

      if (!this.answersMap.has(answerId)) {
        this.answersMap.set(answerId, new Answer(answerDOM, this))
      }
    }
  }

  highlightAnswer (answer) {
    this.answersMap.forEach((_answer) => {
      if (answer.id == _answer.id) {
        answer.addBestLabel()
        answer.removeHighlightButton()

        this.insertAnswer(answer, 0)
      } else {
        _answer.removeBestLabel()
      }
    })
  }

  updateAnswer (id, answerDOM) {
    const answer = this.answersMap.get(id)
    this.DOM.replaceChild(answerDOM, answer.DOM)
    answer.constructor(answerDOM, this)
  }

  insertAnswer (answer, index = null) {
    if (index !== null) {
      this.DOM.insertBefore(answer.DOM, this.DOM.children[index])
    } else {
      this.DOM.append(answer.DOM)
    }
  }

  appendNewAnswer (answerDOM) {
    const answer = new Answer(answerDOM, this)
    this.insertAnswer(answer)
  }

  removeAnswer (id) {
    const answer = this.answersMap.get(id)
    answer.DOM.remove()
  }
}
