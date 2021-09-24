describe 'Answers API', type: :request do
  let(:headers) {
    { "CONTENT_TYPE" => "application/json",
      "ACCEPT" => "application/json" }
  }

  describe 'GET /questions/:id/answers' do
    let(:api_path)  { "/api/v1/questions/#{question.id}/answers"                         }
    let(:options)   { { params: { access_token: access_token.token }, headers: headers } }

    it_behaves_like 'API Authorizable' do
      let(:method) { get }
    end

    context 'authorized' do
      let!(:question)     { create(:question)                                       }
      let!(:answers)      { create_list(:answer, answers_count, question: question) }
      let(:answers_count) { 2                                                       }
      let(:access_token)  { create(:access_token)                                   }
      let(:answer)        { answer.first                                            }
      let(:answer_json)   { json_response['answers'].first                          }

      before { get api_path, options }

      it 'returns list of answers' do
        expect(json_response.size).to eq answers_count
      end

      it 'returns all public fields' do
        %w[id body best author].each do |attr|
          expect(answer_json[attr]).to eq question.send(attr).as_json
        end
      end
    end
  end

  describe 'GET /answers/:id' do
    let!(:answer)  { create(:answer)                                                    }
    let(:api_path) { "/api/v1/answers/#{answer.id}"                                     }
    let(:options)  { { params: { access_token: access_token.token }, headers: headers } }

    it_behaves_like 'API Authorizable' do
      let(:method) { get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token)   }
      let(:answer_json)  { json_response['answer'] }

      it 'returns all public fields' do
        get api_path, options

        %w[id body best author links files comments].each do |attr|
          expect(answer_json[attr]).to eq question.send(attr).as_json
        end
      end
    end
  end
end
