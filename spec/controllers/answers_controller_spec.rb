RSpec.describe AnswersController, type: :controller do
  let(:user)     { create(:user)                                     }
  let(:question) { create(:question)                                 }

  before { login(user) }

  describe 'POST #create' do
    let(:post_create_request) { post :create, params: { answer: answer_params, question_id: question }, format: :js }

    context 'with valid params' do
      let(:answer_params) { attributes_for(:answer) }

      it 'saves a new answer for question in the database' do
        expect { post_create_request }.to change(question.answers, :count).by(1)
      end

      it 'saves answer with attribute best as false' do
        post_create_request

        expect(question.answers.last.best).to be_falsey
      end

      it 'render create view' do
        post_create_request

        expect(response).to render_template 'answers/create'
      end
    end

    context 'with invalid params' do
      let(:answer_params) { attributes_for(:answer, :invalid) }

      it 'does not save answer' do
        expect { post_create_request }.not_to change(Answer, :count)
      end

      it 'render create view' do
        post_create_request

        expect(response).to render_template 'answers/create'
      end
    end
  end

  describe 'PATCH #update' do
    let(:patch_update_request) { patch :update, format: :js, params: { id: answer, answer: answer_params } }
    let(:answer_params)        { attributes_for(:answer, :updated) }

    before { patch_update_request }

    context 'request from author' do
      let(:answer) { create(:answer, question: question, author: user) }

      it 'assigns requested answer to @answer' do
        expect(assigns(:answer)).to eq answer
      end

      context 'with valid params' do
        it 'updates requested answer' do
          answer.reload

          expect(answer).to have_attributes(answer_params)
        end
      end

      context 'with invalid params' do
        let(:answer_params) { attributes_for(:answer, :invalid) }

        it 'does not update requested answer' do
          answer.reload

          expect(answer).to have_attributes(attributes_for(:answer))
        end
      end

      it 'render update view' do
        expect(response).to render_template :update
      end
    end

    context 'request from not author' do
      let(:answer) { create(:answer, question: question) }

      it 'does not update requested answer' do
        answer.reload

        expect(answer).to have_attributes(attributes_for(:answer))
      end

      it 'redirect to show associated question' do
        expect(response).to redirect_to question_path(answer.question)
      end
    end
  end

  describe 'PATCH #update_best' do
    let(:answer) { create(:answer) }
    let(:patch_update_best_request) { patch :update_best, format: :js, params: { id: answer } }

    # before { patch_update_best_request }

    it 'assigns requested answer to @answer' do
      patch_update_best_request

      expect(assigns(:answer)).to eq answer
    end

    context 'request from author of question' do
      let(:question) { create(:question, author: user)     }
      let(:answer)   { create(:answer, question: question) }

      before { login(user) }
      before { patch_update_best_request }


      context 'when another best answer present' do
        # Этот тест падает только потому что этот вопрос не создается
        let!(:another_answer) { create(:answer, question: question, best: true) }

        it 'remove another best answer' do
          expect(another_answer.best).to be_truthy

          another_answer.reload

          expect(another_answer.best).to be_falsey
        end
      end

      it 'update requested answer as best' do
        answer.reload

        expect(answer.best).to be_truthy
        expect(question.answers.where(best: true).count).to eq 1
      end

      it 'render update best view' do
        expect(response).to render_template :update_best
      end
    end

    context 'request from not author of question' do
      before { patch_update_best_request }

      it 'does not update requested answer' do
        answer.reload

        expect(answer.best).to be_falsey
      end

      it 'redirect to question show' do
        expect(response).to redirect_to question_path(answer.question)
      end
    end
  end

  describe 'POST #delete' do
    let(:post_delete_request) { post :destroy, params: { id: answer } }

    context 'request from author' do
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

    context 'request from not author' do
      let!(:answer) { create(:answer, question: question) }

      it 'does not destroy requested answer' do
        expect { post_delete_request }.not_to change(Answer, :count)
      end

      it 'redirect to question show' do
        post :destroy, params: { id: answer }

        expect(response).to redirect_to question_path(question)
      end
    end
  end
end
