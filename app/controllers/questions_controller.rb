class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  before_action :set_question, only: %i[show update destroy]
  after_action  :published, only: :create

  include Rated
  include Commented

  authorize_resource

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
  end

  def new
    @question = Question.new
    @question.build_reward
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      SubscriberService.new(current_user).subscribe_on(@question)
      redirect_to @question, notice: 'Your question successfully created'
    end
  end

  def update
    if FilesUploadService.update_with_files(@question, question_params)
      flash.now[:notice] = 'Your question successfully updated.'
    end
  end

  def destroy
    @question.destroy
    redirect_to questions_path, notice: 'Your question successfully deleted.'
  end

  private

  def set_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body,
                                     files_blob_ids: [],
                                     files: [],
                                     links_attributes: %i[id name url _destroy],
                                     reward_attributes: %i[id name image])
  end

  def published
    return if @question.errors.any?

    ActionCable.server.broadcast(
      "questions_channel",
      ApplicationController.render(
        partial: 'questions/question',
        locals: { question: @question }
      )
    )
  end
end
