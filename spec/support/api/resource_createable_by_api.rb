shared_examples_for 'Resource creatable by API' do
  let(:options) { { params: { :access_token => access_token.token, resource => resource_params } } }
  let(:resource) do
    if model.instance_of? Class
      klass_name = model.to_s
    else
      klass_name = model.klass.to_s
    end
    klass_name.underscore.to_sym
  end

  context 'resource with valid params' do
    let(:resource_params) { attributes_for(resource) }

    it 'saves resource' do
      expect { post api_path, options }.to change(model, :count).by 1
    end

    it 'returns successful response' do
      post api_path, options

      expect(response).to be_successful
    end
  end

  context 'resource with invalid params' do
    let(:resource_params) { attributes_for(resource, :invalid) }

    it 'returns bad request' do
      post api_path, options

      expect(response).to have_http_status :unprocessable_entity
    end

    it 'does not save resource' do
      expect { post api_path, options }.not_to change(model, :count)
    end

    it 'returns errors' do
      post api_path, options

      expect(json_response['errors'][attr]).to contain_exactly error_message
    end
  end
end
