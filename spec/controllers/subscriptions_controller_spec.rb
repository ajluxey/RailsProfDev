RSpec.describe SubscriptionsController, type: :controller do
  describe 'POST #create' do
    let!(:question)      { create(:question) }
    let(:create_request) { post :create, params: { question_id: question, format: :js } }

    context 'when request from authenticated user' do
      let(:user) { create(:user) }

      before { login(user) }

      context  'without subscription' do
        it 'assigns question to @question' do
          create_request

          expect(assigns(:question)).to eq question
        end

        it 'creates subscription' do
          expect { create_request }.to change(Subscription, :count).by(1)
        end

        it 'render create view' do
          create_request

          expect(response).to render_template :create
        end
      end

      context 'with subscription' do
        let!(:subscription) { create(:subscription, user: user, question: question) }

        it 'does not create subscription' do
          expect { create_request }.not_to change(Subscription, :count)
        end
      end
    end

    context 'when request from unauthenticated user' do
      it 'does not create subscription' do
        expect { create_request }.not_to change(Subscription, :count)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:subscription)   { create(:subscription) }
    let(:destroy_request) { delete :destroy, params: { id: subscription, format: :js } }

    context 'when request from authenticated user' do
      let(:user) { create(:user) }

      before { login(user) }

      it 'assigns subscription to @subscription' do
        destroy_request

        expect(assigns(:subscription)).to eq subscription
      end


      context 'which already subscribed' do
        let(:subscription) { create(:subscription, user: user) }

        it 'destroyed subscription' do
          expect { destroy_request }.to change(Subscription, :count).by(-1)
        end

        it 'render destroy view' do
          destroy_request

          expect(response).to render_template :destroy
        end
      end

      it 'which are not subscribed does not destroy' do
        expect { destroy_request }.not_to change(Subscription, :count)
      end
    end

    context 'when request from unauthenticated user' do
      it 'does not destroy' do
        expect { destroy_request }.not_to change(Subscription, :count)
      end
    end
  end
end
