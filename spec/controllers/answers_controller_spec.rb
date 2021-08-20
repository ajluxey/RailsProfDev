RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }

  describe 'GET #new' do
    before { get :new, params: { question_id: question } }

    it 'assigns question to @question which future answer will belongs' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'render new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before { get :edit, params: { id: answer, question_id: question } }

    it 'assigns requested answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'render edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    let(:post_create_request) { post :create, params: { answer: attributes_for(:answer), question_id: question } }

    context 'with valid params' do
      it 'saves a new answer for question in the database' do
        expect { post_create_request }.to change(Answer, :count).by(1).and change(question.answers, :count).by(1)
      end

      it 'redirect to show' do
        post_create_request
        expect(response).to redirect_to assigns(:answer)
      end
    end

    context 'with invalid params' do
      let(:post_create_invalid_request) { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question } }

      it 'does not save answer' do
        expect { post_create_invalid_request }.to_not change(Answer, :count)
      end

      it 're-renders new' do
        post_create_invalid_request
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    before do |test|
      patch :update, params: { id: answer, answer: { body: 'aboba', correct: true } } unless test.metadata[:invalid]
    end

    it 'assigns updated answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end

    context 'with valid params' do
      it 'updates requested question' do
        answer.reload

        expect(answer.body).to eq 'aboba'
        expect(answer.correct).to eq true
      end

      it 'redirect to show' do
        expect(response).to redirect_to answer
      end
    end

    context 'with invalid params', :invalid do
      before { patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) } }

      it 'does not update requested question' do
        answer.reload

        expect(answer.body).to eq "MyText"
        expect(answer.correct).to be_falsey
      end

      it 're-renders edit' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'POST #delete' do
    let!(:answer) { create(:answer, question: question) }

    before do |test|
      post :destroy, params: { id: answer } unless test.metadata[:deleting]
    end

    it 'assigns requested answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'destroy requested answer', :deleting do
      expect { post :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
    end

    it 'redirect to index' do
      expect(response).to redirect_to question_answers_path(question)
    end
  end
end
