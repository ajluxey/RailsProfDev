class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :set_question, only: %i[show update destroy]

  authorize_resource

  def index
    render json: Question.all, each_serializer: QuestionsSerializer
  end

  def show
    render json: @question
  end

  def create
    @question = current_user.questions.build(question_params)

    if @question.save
      render json: @question
    else
      render json: { errors: @question.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @question.update(question_params)
      render json: @question
    else
      render json: { errors: @question.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @question.destroy

    head :ok
  end

  private

  def question_params
    params.require(:question).permit(
      :title,
      :body,
      links_attributes: %i[id name url _destroy]
    )
  end

  def set_question
    @question = Question.find(params[:id])
  end
end
