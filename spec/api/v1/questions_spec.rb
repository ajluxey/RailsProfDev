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

  describe 'POST /questions' do
    let(:question_params) { attributes_for(:question) }
    let(:api_path)        { "/api/v1/questions/"      }
    let(:access_token)    { create(:access_token)     }
    let(:options)         {
      {
        headers: headers,
        params:  { access_token: access_token.token,
                   question: question_params }
      }
    }

    it_behaves_like 'API Authorizable' do
      let(:method) { post }
    end

    context 'authorize' do
      context 'question with valid params' do
        it 'saves question' do
          expect { post api_path, options }.to change(Question, :count).by(1)
        end
      end

      context 'question with invalid params' do
        let(:question_params) { attributes_for(:question, :invalid) }

        it 'returns bad request' do
          post api_path, options

          expect(response).not_to be_successful
        end

        it 'does not save the question' do
          expect { post api_path, options }.not_to change(Question, :count)
        end

        it 'returns errors' do
          post api_path, options

          expect(json_response['errors']['title']).to eq "Title can't be blank"
        end
      end
    end
  end

  describe 'PATCH /questions/:id' do
    let!(:question)       { create(:question)                             }
    let(:question_params) { attributes_for(:question, :new)               }
    let(:api_path)        { "/api/v1/questions/#{question.id}"            }
    let(:access_token)    { create(:access_token)                         }
    let(:options)         {
      {
        headers: headers,
        params:  { access_token: access_token.token,
                   question: question_params }
      }
    }

    it_behaves_like 'API Authorizable' do
      let(:method) { patch }
    end

    context 'authorize' do
      context 'question with valid params' do
        it 'updtes question' do
          patch api_path, options

          question.reload

          expect(question).to have_attributes(question_params)
        end
      end

      context 'question with invalid params' do
        let(:question_params) { attributes_for(:question, :invalid) }

        it 'returns bad request' do
          post api_path, options

          expect(response).not_to be_successful
        end

        it 'does not update question' do
          post api_path, options

          question.reload

          expect(question).to have_attributes(attributes_for(:question))
        end

        it 'returns errors' do
          post api_path, options

          expect(json_response['errors']['title']).to eq "Title can't be blank"
        end
      end
    end
  end

  describe 'DELETE /questions/:id' do
    let!(:question)       { create(:question)                   }
    let(:api_path)        { "/api/v1/questions/#{question.id}"  }
    let(:access_token)    { create(:access_token)               }
    let(:options)         {
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
