RSpec.describe User, type: :model do
  it { should have_many :questions }
  it { should have_many(:questions).dependent(:destroy) }

  it { should have_many :answers }
  it { should have_many(:answers).dependent(:destroy) }

  describe '#author?' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }

    context 'when user is author' do
      let(:question) { create(:question, author: user) }

      it { expect(user.author?(question)).to be_truthy }
    end

    context 'when user is not author' do
      it { expect(user.author?(question)).to be_falsey }
    end
  end
end
