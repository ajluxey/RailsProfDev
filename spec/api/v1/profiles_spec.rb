describe 'Profiles API', type: :request do
  let(:headers) {
    { "CONTENT_TYPE" => "application/json",
      "ACCEPT" => "application/json" }
  }

  describe 'GET /profiles/me' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/profiles/me', headers: headers

        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get '/api/v1/profiles/me', params: { access_token: '1234' }, headers: headers

        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:me)           { create(:user)                                   }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/me', params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response.status).to be_successful
      end

      it 'returns all public fields' do
        %w[id email admin].each do |attr|
          expect(json_response['id']).to eq me.send(attr).as_json
        end
      end

      it 'does not return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(json_response['id']).not_to have_key(attr)
        end
      end
    end
  end
end
