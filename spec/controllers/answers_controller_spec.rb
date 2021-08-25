RSpec.describe AnswersController, type: :controller do
  let(:user)     { create(:user)                                   }
  let(:question) { create(:question)                               }
  let(:answer)   { create(:answer, question: question, user: user) }

  before { login(user) }

  describe 'POST #create' do
    let(:post_create_request) { post :create, params: { answer: answer_params, question_id: question } }

    context 'with valid params' do
      let(:answer_params) { attributes_for(:answer) }

      it 'saves a new answer for question in the database' do
        expect { post_create_request }.to change(question.answers, :count).by(1)
      end

      it 'redirect to question show' do
        post_create_request

        expect(response).to redirect_to question
      end
    end

    context 'with invalid params' do
      let(:answer_params) { attributes_for(:answer, :invalid) }

      it 'does not save answer' do
        expect { post_create_request }.not_to change(Answer, :count)
      end

      it 're-renders form' do
        post_create_request

        expect(response).to render_template "question/show"
      end
    end
  end

  describe 'POST #delete' do
    let(:post_delete_request) { post :destroy, params: { id: answer } }

    context 'when user is author' do
      let!(:answer) { create(:answer, author: user, question: question) }

      it 'assigns requested answer to @answer' do
        post_delete_request

        expect(assigns(:answer)).to eq answer
      end

      it 'destroy requested answer' do
        expect { post_delete_request }.to change(Answer, :count).by(-1)
      end

      it 'redirect to show associated question' do
        post_delete_request

        expect(response).to redirect_to question_path(answer.question)
      end
    end

    context 'when user is not author' do
      let(:answer) { create(:answer, question: question) }

      it 'redirect to question show' do
        post :destroy, params: { id: answer }

        expect(response).to redirect_to question_path(question)
      end
    end
  end
end
