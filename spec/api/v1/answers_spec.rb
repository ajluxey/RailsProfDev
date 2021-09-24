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

  describe 'POST /questions/:id/answers' do
    let!(:question)       { create(:question)                          }
    let(:answer_params)   { attributes_for(:answer)                    }
    let(:api_path)        { "/api/v1/questions/#{question.id}/answers" }
    let(:access_token)    { create(:access_token)                      }
    let(:options)         {
      {
        headers: headers,
        params:  {
          access_token: access_token.token,
          answer: answer_params,
          question_id: question.id
        }
      }
    }

    it_behaves_like 'API Authorizable' do
      let(:method) { post }
    end

    context 'authorize' do
      context 'answer with valid params' do
        it 'saves question' do
          expect { post api_path, options }.to change(Answer, :count).by(1)
        end
      end

      context 'answer with invalid params' do
        let(:question_params) { attributes_for(:answer, :invalid) }

        it 'returns bad request' do
          post api_path, options

          expect(response).not_to be_successful
        end

        it 'does not save the answer' do
          expect { post api_path, options }.not_to change(Answer, :count)
        end

        it 'returns errors' do
          post api_path, options

          expect(json_response['errors']['body']).to eq "Body can't be blank"
        end
      end
    end
  end

  describe 'PATCH /answers/:id' do
    let!(:question)       { create(:question)                 }
    let!(:answer)         { create(:answer)                   }
    let(:answer_params)   { attributes_for(:answer, :invalid) }
    let(:api_path)        { "/api/v1/answers/#{answer.id}"    }
    let(:access_token)    { create(:access_token)             }
    let(:options)         {
      {
        headers: headers,
        params:  {
          access_token: access_token.token,
          answer: answer_params
        }
      }
    }

    it_behaves_like 'API Authorizable' do
      let(:method) { patch }
    end

    context 'authorize' do
      context 'answer with valid params' do
        it 'updates answer' do
          patch api_path, options

          answer.reload

          expect(answer).to have_attributes(answer_params)
        end
      end

      context 'answer with invalid params' do
        let(:answer_params) { attributes_for(:answer, :invalid) }

        it 'returns bad request' do
          post api_path, options

          expect(response).not_to be_successful
        end

        it 'does not update answer' do
          post api_path, options

          answer.reload

          expect(question).to have_attributes(attributes_for(:answer))
        end

        it 'returns errors' do
          post api_path, options

          expect(json_response['errors']['body']).to eq "Body can't be blank"
        end
      end
    end
  end

  describe 'DELETE /answers/:id' do
    let1(:answer)      { create(:answer)                }
    let(:api_path)     { "/api/v1/answers/#{answer.id}" }
    let(:access_token) { create(:access_token)          }
    let(:options)      {
      {
        headers: headers,
        params:  { access_token: access_token.token }
      }
    }

    it_behaves_like 'API Authorizable' do
      let(:method) { delete }
    end
  end
end
