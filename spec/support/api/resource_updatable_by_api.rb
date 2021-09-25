shared_examples_for 'Resource updatable by API' do
  let(:options)  { { params: { :access_token => access_token.token, resource => resource_params } } }
  let(:resource) { existed_resource.class.to_s.underscore.to_sym }

  context 'with valid params' do
    let(:resource_params) { attributes_for(resource, :updated) }

    it 'updates resource' do
      patch api_path, options

      existed_resource.reload

      expect(existed_resource).to have_attributes(resource_params)
    end

    it 'returns successful response' do
      patch api_path, options

      expect(response).to be_successful
    end
  end

  context 'with invalid params' do
    let(:resource_params) { attributes_for(resource, :invalid) }

    it 'returns bad request' do
      patch api_path, options

      expect(response).not_to be_successful
    end

    it 'does not update answer' do
      patch api_path, options

      existed_resource.reload

      expect(existed_resource).to have_attributes(attributes_for(resource))
    end

    it 'returns errors' do
      patch api_path, options

      expect(json_response['errors'][attr]).to contain_exactly error_message
    end
  end
end
