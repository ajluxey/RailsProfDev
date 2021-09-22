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

        expect(response).to render_template :create
      end
    end

    context 'with invalid params' do
      let(:answer_params) { attributes_for(:answer, :invalid) }

      it 'does not save answer' do
        expect { post_create_request }.not_to change(Answer, :count)
      end

      it 'render create view' do
        post_create_request

        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    let(:patch_update_request) { patch :update, format: :js, params: { id: answer, answer: answer_params } }
    let(:answer_params)        { attributes_for(:answer, :updated) }

    before do |test|
      patch_update_request unless test.metadata[:update_with_files]
    end

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

      context 'files updates when another file exists', :update_with_files do
        let!(:answer) { create(:answer_with_file, author: user) }

        context 'by adding file' do
          let(:answer_params) { { files: [fixture_file_upload("#{Rails.root.join('spec', 'spec_helper.rb')}")] } }

          it { expect { patch_update_request }.to change(answer.files, :count).by(1) }
        end

        context 'by deleting file' do
          let(:answer_params) { { files_blob_ids: ['', answer.files.first.id.to_s] } }

          it { expect { patch_update_request }.to change(answer.files, :count).by(-1) }
        end
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
    let(:question) { create(:question)                   }
    let(:answer)   { create(:answer, question: question) }
    let(:patch_update_best_request) { patch :update_best, format: :js, params: { id: answer } }

    it 'assigns requested answer to @answer' do
      patch_update_best_request

      expect(assigns(:answer)).to eq answer
    end

    context 'request from author of question' do
      let(:question) { create(:question, author: user) }

      context 'when another best answer present' do
        let!(:another_answer) { create(:answer, question: question, best: true) }

        it 'remove best status from another answer' do
          expect(another_answer.best).to be_truthy

          patch_update_best_request
          another_answer.reload

          expect(another_answer.best).to be_falsey
        end
      end

      it 'update requested answer as best' do
        patch_update_best_request
        answer.reload

        expect(answer.best).to be_truthy
        expect(question.answers.where(best: true).count).to eq 1
      end

      it 'render update best view' do
        patch_update_best_request

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

  describe 'PATCH #rate' do
    let(:patch_rate_request) { patch :rate, format: :json, params: { id: answer } }
    let(:answer) { create(:answer) }

    context 'update request from author' do
      let(:answer) { create(:answer, author: user) }

      it 'does not update answer' do
        expect { patch_rate_request }.not_to change(answer, :rating)
      end
    end

    it 'updates answer rating' do
      expect { patch_rate_request }.to change(answer, :rating).by(1)
    end

    it 'does not update answer rating when user has already rates' do
      RegisterRatingService.from(user).for(answer).register_rate
      answer.reload

      expect { patch_rate_request }.not_to change(answer, :rating)
    end
  end

  describe 'PATCH #rate_against' do
    let(:patch_rate_against_request) { patch :rate_against, format: :json, params: { id: answer } }
    let(:answer) { create(:answer) }

    context 'update request from author' do
      let(:answer) { create(:answer, author: user) }

      it 'does not update answer' do
        expect { patch_rate_against_request }.not_to change(answer, :rating)
      end
    end

    it 'updates answer rating' do
      expect { patch_rate_against_request }.to change(answer, :rating).by(-1)
    end

    it 'does not update answer rating when user has already rates against' do
      RegisterRatingService.from(user).for(answer).register_rate_against
      answer.reload

      expect { patch_rate_against_request }.not_to change(answer, :rating)
    end
  end

  describe 'PATCH #cancel_rate' do
    let(:patch_cancel_rating_request) { patch :cancel_rating, format: :json, params: { id: answer } }
    let(:answer) { create(:answer) }

    it 'does not update answer rating that has not been rated' do
      expect { patch_cancel_rating_request }.not_to change(answer, :rating)
    end

    it 'updates answer rating when user has already rates' do
      RegisterRatingService.from(user).for(answer).register_rate
      answer.reload

      expect { patch_cancel_rating_request }.to change(answer, :rating).by(-1)
    end
  end

  describe 'POST #delete' do
    let(:post_delete_request) { post :destroy, format: :js, params: { id: answer } }

    context 'request from author' do
      let!(:answer) { create(:answer, author: user, question: question) }

      it 'assigns requested answer to @answer' do
        post_delete_request

        expect(assigns(:answer)).to eq answer
      end

      it 'destroy requested answer' do
        expect { post_delete_request }.to change(Answer, :count).by(-1)
      end

      it 'render destroy view' do
        post_delete_request

        expect(response).to render_template :destroy
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
