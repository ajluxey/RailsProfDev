describe 'Answers API', type: :request do
  let!(:question)    { create(:question)                                 }
  let(:user)         { create(:user)                                     }
  let(:access_token) { create(:access_token, resource_owner_id: user.id) }
  let(:options)      { { params: { access_token: access_token.token } }  }


  describe 'GET /questions/:id/answers' do
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let!(:answers)      { create_list(:answer, answers_count, question: question) }
      let(:answers_count) { 2                                                       }
      let(:answer)        { answers.first                                           }
      let(:answer_json)   { json_response['answers'].last                           }

      before { get api_path, options }

      it 'returns list of answers' do
        expect(json_response['answers'].size).to eq answers_count
      end

      it 'returns all public fields' do
        %w[id body best].each do |attr|
          expect(answer_json[attr]).to eq answer.send(attr).as_json
        end
      end
    end
  end

  describe 'GET /answers/:id' do
    let!(:answer)  { create(:answer)                }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:answer_json)  { json_response['answer'] }

      it 'returns all public fields' do
        get api_path, options

        %w[id body best links comments].each do |attr|
          expect(answer_json[attr]).to eq answer.send(attr).as_json
        end
      end
    end
  end

  describe 'POST /questions/:id/answers' do
    let(:answer_params) { attributes_for(:answer)                                                 }
    let(:api_path)      { "/api/v1/questions/#{question.id}/answers"                              }
    let(:options)       { { params: { access_token: access_token.token, answer: answer_params } } }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context 'authorize' do
      it_behaves_like 'Resource creatable by API' do
        let(:model)         { question.answers }
        let(:attr)          { 'body'           }
        let(:error_message) { "can't be blank" }
      end
    end
  end

  describe 'PATCH /answers/:id' do
    let!(:answer)       { create(:answer, author: user)                                           }
    let(:answer_params) { attributes_for(:answer, :updated)                                       }
    let(:api_path)      { "/api/v1/answers/#{answer.id}"                                          }
    let(:options)       { { params: { access_token: access_token.token, answer: answer_params } } }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    context 'authorize' do
      it_behaves_like 'Resource updatable by API' do
        let(:existed_resource) { answer           }
        let(:attr)             { 'body'           }
        let(:error_message)    { "can't be blank" }
      end
    end
  end

  describe 'DELETE /answers/:id' do
    let!(:answer)  { create(:answer, author: user)  }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    it { expect { delete api_path, options }.to change(Answer, :count).by(-1) }
  end
end
