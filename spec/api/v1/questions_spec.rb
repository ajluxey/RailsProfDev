describe 'Questions API', type: :request do
  let(:headers) {
    { "CONTENT_TYPE" => "application/json",
      "ACCEPT" => "application/json" }
  }

  describe 'GET /questions' do
    let(:api_path)     { '/api/v1/questions'                                                }
    let(:access_token) { create(:access_token)                                              }
    let(:options)      { { params: { access_token: access_token.token }, headers: headers } }

    it_behaves_like 'API Authorizable' do
      let(:method) { get }
    end

    context 'authorized' do
      let(:questions_count) { 2                                      }
      let!(:questions)      { create_list(:question, question_count) }
      let(:question)        { questions.first                        }
      let(:question_json)   { json_response['questions'].first       }

      before { get api_path, options }

      it 'returns list of questions' do
        expect(json_response.size).to eq question_count
      end

      it 'returns all public fields' do
        %w[id title body author].each do |attr|
          expect(question_json[attr]).to eq question.send(attr).as_json
        end
      end
    end
  end

  describe 'GET /questions/:id' do
    let!(:question)     { create(:question)                                                  }
    let(:api_path)      { "/api/v1/questions/#{question.id}"                                 }
    let(:access_token)  { create(:access_token)                                              }
    let(:options)       { { params: { access_token: access_token.token }, headers: headers } }

    it_behaves_like 'API Authorizable' do
      let(:method) { get }
    end

    context 'authorized' do
      let(:question_json) { json_response['question'] }

      it 'returns all public fields' do
        get api_path, options

        %w[id title body author links files comments].each do |attr|
          expect(question_json[attr]).to eq question.send(attr).as_json
        end
      end
    end
  end
end

