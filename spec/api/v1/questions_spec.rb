describe 'Questions API', type: :request do
  let(:user)         { create(:user)                                     }
  let(:access_token) { create(:access_token, resource_owner_id: user.id) }
  let(:options)      { { params: { access_token: access_token.token } }  }

  describe 'GET /questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:questions_count) { 2                                       }
      let!(:questions)      { create_list(:question, questions_count) }
      let(:question)        { questions.first                         }
      let(:question_json)   { json_response['questions'].first        }

      before { get api_path, options }

      it 'returns list of questions' do
        expect(json_response['questions'].size).to eq questions_count
      end

      it 'returns all public fields' do
        %w[id title body].each do |attr|
          expect(question_json[attr]).to eq question.send(attr).as_json
        end
      end
    end
  end

  describe 'GET /questions/:id' do
    let!(:question) { create(:question)                  }
    let(:api_path)  { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:question_json) { json_response['question'] }

      it 'returns all public fields' do
        get api_path, options

        %w[id title body links comments].each do |attr|
          expect(question_json[attr]).to eq question.send(attr).as_json
        end
      end
    end
  end

  describe 'POST /questions' do
    let(:question_params) { attributes_for(:question)                                                   }
    let(:api_path)        { "/api/v1/questions/"                                                        }
    let(:options)         { { params: { access_token: access_token.token, question: question_params } } }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context 'authorize' do
      it_behaves_like 'Resource creatable by API' do
        let(:model)         { Question         }
        let(:attr)          { 'title'          }
        let(:error_message) { "can't be blank" }
      end
    end
  end

  describe 'PATCH /questions/:id' do
    let!(:question)       { create(:question, author: user)                                             }
    let(:question_params) { attributes_for(:question, :updated)                                         }
    let(:api_path)        { "/api/v1/questions/#{question.id}"                                          }
    let(:options)         { { params: { access_token: access_token.token, question: question_params } } }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    context 'authorize' do
      it_behaves_like 'Resource updatable by API' do
        let(:existed_resource) { question         }
        let(:attr)             { 'title'          }
        let(:error_message)    { "can't be blank" }
      end
    end
  end

  describe 'DELETE /questions/:id' do
    let!(:question) { create(:question, author: user)    }
    let(:api_path)  { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    it { expect { delete api_path, options }.to change(Question, :count).by(-1) }
  end
end
