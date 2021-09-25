describe 'Profiles API', type: :request do
  let(:headers) {
    { "CONTENT_TYPE" => "application/json",
      "ACCEPT" => "application/json" }
  }
  let(:access_token) { create(:access_token, resource_owner_id: me.id)                    }
  let(:options)      { { params: { access_token: access_token.token }, headers: headers } }

  describe 'GET /profiles/me' do
    let(:api_path) { '/api/v1/profiles/me' }
    let(:me)       { create(:user)         }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:user_json) { json_response['user'] }

      before { get api_path, options }

      it 'returns all public fields' do
        %w[id email].each do |attr|
          expect(user_json[attr]).to eq me.send(attr).as_json
        end
      end

      it 'does not return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(user_json).not_to have_key(attr)
        end
      end
    end
  end

  describe 'GET /profiles/other_users' do
    let(:api_path)     { '/api/v1/profiles/other_users' }
    let!(:users)       { create_list(:user, 6)          }
    let(:me)           { users.first                    }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:users_json) { json_response['users'] }
      let(:user_json)  { users_json.last        }
      let(:user)       { users.last             }

      before { get api_path, options }

      it 'returns list of users without requester' do
        expect(users_json.size).to eq 5
      end

      it 'returns all public fields' do
        %w[id email].each do |attr|
          expect(user_json[attr]).to eq user.send(attr).as_json
        end
      end

      it 'does not return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(user_json).not_to have_key(attr)
        end
      end
    end
  end
end
