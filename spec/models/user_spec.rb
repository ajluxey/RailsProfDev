RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:rewards).dependent(:nullify) }

  describe '#author?' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }

    context 'when user is author' do
      let(:question) { create(:question, author: user) }

      it { expect(user).to be_author(question) }
    end

    context 'when user is not author' do
      it { expect(user).not_to be_author(question) }
    end
  end
end
