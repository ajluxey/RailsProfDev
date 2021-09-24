class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :set_question, only: %i[show update delete]

  authorize_resource

  def index
    render json: Question.all, each_serializer: QuestionsSerializer
  end

  def show
    render json: @question
  end

  def create
    @question = Question.new(question_params)

    if @question.save
      render json: @question
    else
      render json: @question.errors, status: :unprocessable_entity
    end
  end

  def update
    if @question.update(question_params)
      render json: @question
    else
      render json: @question.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @question.destroy

    if @question.destroyed?
      render status: :bad_request
    else
      render stats: :ok
    end
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
