class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  before_action :set_question, only: %i[show edit update destroy]
  before_action :required_author!, only: %i[edit update destroy]

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
  end

  def new
    @question = Question.new
  end

  def edit
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question, notice: 'Your question successfully created'
    else
      render :new
    end
  end

  def update
    if @question.update(question_params)
      flash.now[:notice] = 'Your question successfully updated.'
    end
  end

  def destroy
    @question.destroy
    redirect_to questions_path, notice: 'Your question successfully deleted.'
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end

  def required_author!
    redirect_to question_path(@question), alert: 'You must be author' unless current_user.author?(@question)
  end
end
