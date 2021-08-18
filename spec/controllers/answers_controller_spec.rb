RSpec.describe AnswersController, type: :controller do
  before(:each) do
    @question = create(:question)
    @parent_url = { question_id: @question }
  end

  let(:answer) { create(:answer, question: @question) }

  describe 'GET #index' do
    let(:answers) { create_list(:answer, 4, question: @question) }
    before { get :index, params: @parent_url }

    it 'populate an array of all answers for question' do
      expect(assigns(:answers)).to match_array(answers)
    end

    it 'render index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: answer } }

    it 'assigns requested answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'render show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { get :new, params: @parent_url }

    it 'assigns question to @question which future answer will belongs' do
      expect(assigns(:question)).to eq @question
    end

    it 'assigns new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'render new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before { get :edit, params: { id: answer }.merge(@parent_url) }

    it 'assigns requested answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'render edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'saves a new answer for question in the database' do
        expect { post :create, params: { answer: attributes_for(:answer) }.merge(@parent_url) }.to change(Answer, :count).by(1)
      end

      it 'redirect to show' do
        post :create, params: { answer: attributes_for(:answer) }.merge(@parent_url)
        expect(response).to redirect_to assigns(:answer)
      end
    end

    context 'with invalid params' do
      it 'does not save answer' do
        expect { post :create, params: { answer: attributes_for(:answer, :invalid) }.merge(@parent_url) }.to_not change(Answer, :count)
      end

      it 're-renders new' do
        post :create, params: { answer: attributes_for(:answer, :invalid) }.merge(@parent_url)
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    it 'assigns updated answer to @answer' do
      patch :update, params: { id: answer, answer: { body: 'aboba', correct: true } }
      expect(assigns(:answer)).to eq answer
    end

    context 'with valid params' do
      before { patch :update, params: { id: answer, answer: { body: 'aboba', correct: true } } }

      it 'updates requested question' do
        answer.reload

        expect(answer.body).to eq 'aboba'
        expect(answer.correct).to eq true
      end

      it 'redirect to show' do
        expect(response).to redirect_to answer
      end
    end

    context 'with invalid params' do
      before { patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) } }

      it 'does not update requested question' do
        answer.reload

        expect(answer.body).to eq "MyText"
        expect(answer.correct).to eq false
      end

      it 're-renders edit' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'POST #delete' do
    let!(:answer) { create(:answer, question: @question) }

    before(:each) do |test|
      post :destroy, params: { id: answer } unless test.metadata[:deleting]
    end

    it 'assigns requested answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'destroy requested question', :deleting do
      expect { post :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
    end

    it 'redirect to index' do
      expect(response).to redirect_to question_answers_path(@question)
    end
  end
end
