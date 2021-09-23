RSpec.describe RewardsController, type: :controller do
  describe "GET #index" do
    let(:user) { create(:user) }

    it 'render template index for authenticated user' do
      login(user)

      get :index

      expect(response).to render_template :index
    end

    it 'redirect to sign in for unauthenticated user' do
      get :index

      expect(response).to redirect_to new_user_session_path
    end
  end
end
