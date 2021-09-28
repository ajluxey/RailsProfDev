RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy)     }
  it { should have_many(:answers).dependent(:destroy)       }
  it { should have_many(:rewards).dependent(:nullify)       }
  it { should have_many(:ratings).dependent(:destroy)       }
  it { should have_many(:comments).dependent(:destroy)      }
  it { should have_many(:subscriptions).dependent(:destroy) }

  let(:user) { create(:user) }

  describe '#author?' do
    let(:question) { create(:question) }

    context 'when user is author' do
      let(:question) { create(:question, author: user) }

      it { expect(user).to be_author(question) }
    end

    context 'when user is not author' do
      it { expect(user).not_to be_author(question) }
    end
  end

  describe '#subscribed_on?' do
    let(:question) { create(:question) }

    context 'when user subscribed' do
      let!(:subscription) { create(:subscription, user: user, question: question) }

      it { expect(user).to be_subscribed_on(question) }
    end

    context 'when user unsubscribed' do
      it { expect(user).not_to be_subscribed_on(question) }
    end
  end
end
