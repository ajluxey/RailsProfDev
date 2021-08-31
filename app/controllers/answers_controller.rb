class AnswersController < ApplicationController
  before_action :set_answer, only: %i[update update_best destroy]
  before_action :required_author!, only: %i[update destroy]
  before_action :required_question_author!, only: :update_best

  def create
    @question = Question.find(params[:question_id])

    @answer = @question.answers.build(answer_params)
    @answer.author = current_user

    if @answer.save
      flash.now[:notice] = 'Your answer successfully created.'
    end
  end

  def update
    if @answer.update(answer_params)
      flash.now[:notice] = 'Your answer successfully updated.'
    end
  end

  def update_best
    @previous_best = @answer.is_best!
    flash.now[:notice] = 'Best answer successfully highlighted'
  end

  def destroy
    @answer.destroy
    redirect_to question_path(@answer.question), notice: 'Your answer successfully deleted.'
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end

  def required_author!
    redirect_to question_path(@answer.question), alert: 'You must be author' unless current_user.author?(@answer)
  end

  def required_question_author!
    redirect_to question_path(@answer.question), alert: 'You must be author of question' unless current_user.author?(@answer.question)
  end
end
