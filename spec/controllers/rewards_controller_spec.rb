RSpec.describe RewardsController, type: :controller do
  describe "GET #index" do
    let(:user) { create(:user) }

    it 'render template index' do
      login(user)

      get :index

      expect(response).to render_template :index
    end
  end
end
