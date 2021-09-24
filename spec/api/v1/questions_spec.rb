describe 'Questions API', type: :request do
  let(:headers) {
    { "CONTENT_TYPE" => "application/json",
      "ACCEPT" => "application/json" }
  }

  describe 'GET /questions' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/questions', headers: headers

        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get '/api/v1/questions', params: { access_token: '1234' }, headers: headers

        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token)  { create(:access_token)                        }
      let!(:questions)     { create_list(:question, 2)                   }
      let(:question)      { questions.first                              }
      let(:question_json) { json_response['questions'].first             }
      let!(:answers)       { create_list(:answer, 2, question: question) }

      before { get '/api/v1/questions', params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response.status).to be_successful
      end

      it 'returns list of questions' do
        expect(json_response.size).to eq 2
      end

      it 'returns all public fields' do
        %w[id title body author_id created_at updated_at].each do |attr|
          expect(question_json['id']).to eq question.send(attr).as_json
        end
      end

      describe 'user' do
        let(:user_json) { question_json['author'] }

        it 'returns correct user' do
          expect(user_json['id']).to eq question.author.id
        end
      end

      describe 'answers' do
        let(:answer)       { answers.first            }
        let(:answers_json) { question_json['answers'] }

        it 'returns list of answers' do
          expect(answers_json.size).to eq 2
        end

        it 'returns all public fields' do
          %w[id title body author_id].each do |attr|
            expect(answers_json.first[attr]).to eq answer.send(attr).as_json
          end
        end

      end
    end
  end
end

