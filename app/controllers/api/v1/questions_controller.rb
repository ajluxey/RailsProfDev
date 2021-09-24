class Api::V1::QuestionsController < Api::V1::BaseController
  def index
    render json: Question.all, each_serializer: QuestionsSerializer
  end

  def show
    @question = Question.find(params[:id])
    render json: @question
  end
end
