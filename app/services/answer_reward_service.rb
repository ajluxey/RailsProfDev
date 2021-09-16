class AnswerRewardService
  def self.reward_for_this_answer(answer)
    service = new(answer)
    service.reward_author
  end

  def initialize(answer)
    @answer = answer
    @reward = answer.question.reward
  end

  def reward_author
    reward_author! if can_be_rewarded?
  end

  private

  def can_be_rewarded?
    @reward.present?
  end

  def reward_author!
    @reward.update(respondent: @answer.author)
  end
end