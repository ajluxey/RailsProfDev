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
    let(:post_create_request) { post :create, params: { answer: answer_params, question_id: question } }

    context 'with valid params' do
      let(:answer_params) { attributes_for(:answer) }

      it 'saves a new answer for question in the database' do
        expect { post_create_request }.to change(question.answers, :count).by(1)
      end

      it 'redirect to show' do
        post_create_request
        expect(response).to redirect_to assigns(:answer)
      end
    end

    context 'with invalid params' do
      let(:answer_params) { attributes_for(:answer, :invalid) }

      it 'does not save answer' do
        expect { post_create_request }.not_to change(Answer, :count)
      end

      it 're-renders new' do
        post_create_request
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    let(:answer_params) { attributes_for(:answer, :updated) }

    before { patch :update, params: { id: answer, answer: answer_params } }

    it 'assigns updated answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end

    context 'with valid params' do
      it 'updates requested question' do
        answer.reload

        expect(answer).to have_attributes(answer_params)
      end

      it 'redirect to show' do
        expect(response).to redirect_to answer
      end
    end

    context 'with invalid params' do
      let(:answer_params) { attributes_for(:answer, :invalid) }

      it 'does not update requested question' do
        answer.reload

        expect(answer).to have_attributes(attributes_for(:answer))
      end

      it 're-renders edit' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'POST #delete' do
    let!(:answer) { create(:answer, question: question) }
    let(:post_delete_request) { post :destroy, params: { id: answer } }

    it 'assigns requested answer to @answer' do
      post_delete_request
      expect(assigns(:answer)).to eq answer
    end

    it 'destroy requested answer' do
      expect { post_delete_request }.to change(Answer, :count).by(-1)
    end

    it 'redirect to index' do
      post_delete_request
      expect(response).to redirect_to question_answers_path(question)
    end
  end
end
