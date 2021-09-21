class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  before_action :set_question, only: %i[show edit update destroy]
  before_action :required_author!, only: %i[edit update destroy]

  include Rated
  include Commented

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

  def edit
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
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

  def required_author!
    redirect_to question_path(@question), alert: 'You must be author' unless current_user.author?(@question)
  end
end
