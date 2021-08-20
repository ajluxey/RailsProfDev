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
      let(:post_create_request) { post :create, params: { question: attributes_for(:question) } }

      it 'saves a new question in the database' do
        expect { post_create_request }.to change(Question, :count).by(1)
      end

      it 'redirect to show' do
        post_create_request
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid params' do
      let(:post_create_invalid_request) { post :create, params: { question: attributes_for(:question, :invalid) } }

      it 'does not save the question' do
        expect { post_create_invalid_request }.to_not change(Question, :count)
      end

      it 're-renders new' do
        post_create_invalid_request
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    before do |test|
      patch :update, params: { id: question, question: { title: '123', body: '124' } } unless test.metadata[:invalid]
    end

    it 'assigns requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    context 'with valid params' do
      it 'updates requested question' do
        question.reload

        expect(question.title).to eq '123'
        expect(question.body).to eq '124'
      end

      it 'redirect to show' do
        expect(response).to redirect_to question
      end
    end

    context 'with invalid params', :invalid do
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
    let(:post_delete_request) { delete :destroy, params: { id: question } }
    let!(:question) { create(:question) }

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
end
