RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3) }

    before { get :index }

    it 'populate an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'render index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assigns requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'render show view' do
      expect(response).to render_template :show
    end
  end

  context 'when logged in' do
    let(:user) { create(:user) }

    before { login(user) }

    describe 'GET #new' do
      before { get :new }

      it 'assigns new Question to @question' do
        expect(assigns(:question)).to be_a_new(Question)
      end

      it 'render new view' do
        expect(response).to render_template :new
      end
    end

    describe 'POST #create' do
      let(:post_create_request) { post :create, format: :js, params: { question: question_params } }
      let(:user)                { create(:user)                                                    }

      before { login(user) }

      context 'with valid params' do
        let(:question_params) { attributes_for(:question) }

        it 'saves a new question for user in the database' do
          expect { post_create_request }.to change(subject.current_user.questions, :count).by(1)
        end

        it 'redirect to show' do
          post_create_request

          expect(response).to redirect_to assigns(:question)
        end
      end

      context 'with invalid params' do
        let(:question_params) { attributes_for(:question, :invalid) }

        it 'does not save the question' do
          expect { post_create_request }.not_to change(Question, :count)
        end

        it 'render create view' do
          post_create_request

          expect(response).to render_template :create
        end

      end
    end

    describe 'GET #edit' do
      before { get :edit, params: { id: question } }

      context 'request from author' do
        let(:question) { create(:question, author: user) }

        it 'assigns requested question to @question' do
          expect(assigns(:question)).to eq question
        end

        it 'render edit view' do
          expect(response).to render_template :edit
        end
      end

      context 'request from not author' do
        it { expect(response).to redirect_to question_path(question) }
      end
    end

    describe 'PATCH #update' do
      let(:patch_update_request) { patch :update, format: :js, params: { id: question, question: question_params } }
      let(:question_params) { attributes_for(:question, :updated) }

      before do |test|
        patch_update_request unless test.metadata[:update_with_files]
      end

      context 'request from author' do
        let(:question) { create(:question, author: user) }

        it 'assigns requested question to @question' do
          expect(assigns(:question)).to eq question
        end

        context 'with valid params' do
          it 'updates requested question' do
            question.reload

            expect(question).to have_attributes(question_params)
          end
        end

        context 'with invalid params' do
          let(:question_params) { attributes_for(:question, :invalid) }

          it 'does not update requested question' do
            question.reload

            expect(question).to have_attributes(attributes_for(:question))
          end
        end

        context 'files updates when another file exists', :update_with_files do
          let!(:question) { create(:question_with_file, author: user) }

          context 'by adding' do
            let(:question_params) { { files: [fixture_file_upload("#{Rails.root.join('spec', 'rails_helper.rb')}")] } }

            it { expect { patch_update_request }.to change(question.files, :count).by(1) }
          end

          context 'by deleting file' do
            let(:question_params) { { files_blob_ids: ['', question.files.first.id.to_s] } }

            it { expect { patch_update_request }.to change(ActiveStorage::Attachment, :count).by(-1) }
          end
        end

        it 'render update view' do
          expect(response).to render_template :update
        end
      end

      context 'request from not author' do
        it 'does not update requested question' do
          question.reload

          expect(question).to have_attributes(attributes_for(:question))
        end

        it { expect(response).to redirect_to question_path(question) }
      end
    end

    describe 'POST #delete' do
      let(:post_delete_request) { delete :destroy, format: :js, params: { id: question } }
      let!(:question) { create(:question) }

      context 'request from author' do
        let!(:question) { create(:question, author: user) }

        it 'assigns requested question to @question' do
          post_delete_request

          expect(assigns(:question)).to eq question
        end

        it 'destroy requested question' do
          expect { post_delete_request }.to change(Question, :count).by(-1)
        end

        it 'redirect to index' do
          post_delete_request

          expect(response).to redirect_to questions_path
        end
      end

      context 'request from not author' do
        it 'does not destroy requested question' do
          expect { post_delete_request }.not_to change(Question, :count)
        end

        it 'redirect to questions' do
          post_delete_request

          expect(response).to redirect_to question_path(question)
        end
      end
    end
  end
end
