class Api::V1::AnswersController < Api::V1::BaseController
  before_action :set_question, only: %i[index create]
  before_action :set_answer, only: %i[show update delete]

  authorize_resource

  def index
    render json: @question.answers, each_serializer: AnswersSerializer
  end

  def show
    render json: @answer
  end

  def create
    @answer = @question.answers.new(answer_params)

    if @answer.save
      render json: @answer
    else
      render json: @answer.errors, status: :unprocessable_entity
    end
  end

  def update
    if @answer.update(answer_params)
      render json: @answer
    else
      render json: @answer.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @answer.destroy

    if @answer.destroyed?
      render status: :unprocessable_entity
    else
      render stats: :ok
    end
  end

  private

  def answers_params
    params.require(:answer).permit(:body, links_attributes: %i[id name url _destroy])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end
end
