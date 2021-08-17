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

    it 'render show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { get :new }

    it 'assigns new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'render new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before { get :edit, params: { id: question } }

    it 'assigns requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'render edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'saves a new question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'redirect to show' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid params' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
      end

      it 're-renders new' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    it 'assigns requested question to @question' do
      patch :update, params: { id: question, question: attributes_for(:question) }
      expect(assigns(:question)).to eq question
    end

    context 'with valid params' do
      it 'updates requested question' do
        patch :update, params: { id: question, question: { title: '123', body: '124' } }
        question.reload

        expect(question.title).to eq '123'
        expect(question.body).to eq '124'
      end

      it 'redirect to show' do
        patch :update, params: { id: question, question: attributes_for(:question) }
        expect(response).to redirect_to question
      end
    end

    context 'with invalid params' do
      before { patch :update, params: { id: question, question: attributes_for(:question, :invalid) } }

      it 'does not update requested question' do
        question.reload

        expect(question.title).to eq "MyString"
        expect(question.body).to eq "MyText"
      end

      it 'rerender edit' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'POST #delete' do
    let!(:question) { create(:question) }

    it 'assigns requested question to @question' do
      delete :destroy, params: { id: question }
      expect(assigns(:question)).to eq question
    end

    it 'destroy requested question' do
      expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
    end

    it 'redirect to index' do
      delete :destroy, params: { id: question }
      expect(response).to redirect_to questions_path
    end
  end
end
