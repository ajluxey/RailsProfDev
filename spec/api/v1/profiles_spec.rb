describe 'Profiles API', type: :request do
  let(:headers) {
    { "CONTENT_TYPE" => "application/json",
      "ACCEPT" => "application/json" }
  }

  describe 'GET profiles/me' do
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
        expect(response.status).to eq 200
      end

      it 'returns all public fields' do
        json = JSON.parse(response.body)

        expect(json['id'].to eq me.id)
      end
    end
  end
end
