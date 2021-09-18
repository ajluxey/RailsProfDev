RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy)   }
  it { should have_many(:rewards).dependent(:nullify)   }
  it { should have_many(:ratings).dependent(:destroy)   }

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

  let(:user) { create(:user) }

  describe '#rates' do
    let(:rateable) { create(:answer) }

    context 'when user is author' do
      let(:rateable) { create(:answer, author: user) }

      it 'does not update rating of rateable resource' do
        expect { user.rates(rateable) }.not_to change(rateable, :rating)
      end
    end

    it 'updates rating of rateable resource' do
      expect { user.rates(rateable) }.to change(rateable, :rating).by(1)
    end
  end

  describe '#rates_against' do
    let(:rateable) { create(:answer) }

    context 'when user is author' do
      let(:rateable) { create(:answer, author: user) }

      it 'does not update rating of rateable resource' do
        expect { user.rates_against(rateable) }.not_to change(rateable, :rating)
      end
    end

    it 'updates rating of rateable resource' do
      expect { user.rates_against(rateable) }.to change(rateable, :rating).by(-1)
    end
  end

  describe '#cancel_rating_for' do
    let(:rateable) { create(:answer) }

    context 'when user is author' do
      let(:rateable) { create(:answer, author: user) }

      it 'does not update rating of rateable resource' do
        expect { user.cancel_rating_for(rateable) }.not_to change(rateable.user_marks, :count)
        expect(user.cancel_rating_for(rateable)).to be_falsey
      end
    end

    context 'when user already rates' do
      let(:rateable) { create(:answer) }

      before do
        user.rates(rateable)
        rateable.reload
      end

      it 'remove rate from rateable resource' do
        expect { user.cancel_rating_for(rateable) }.to change(rateable.user_marks, :count).by(-1)
      end

      it { expect(user.cancel_rating_for(rateable)).to be_truthy }
    end

    context 'when user did not rates does not remove any rating record' do
      it { expect { user.cancel_rating_for(rateable) }.not_to change(rateable.user_marks, :count) }
    end
  end
end
