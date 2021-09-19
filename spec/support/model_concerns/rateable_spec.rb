shared_examples_for "rateable" do
  let(:model)    { described_class                      }
  let(:user)     { create(:user)                        }
  let(:rateable) { create(model.to_s.underscore.to_sym) }

  it { should have_many(:user_marks).dependent(:destroy) }

  describe '#rating' do
    it 'returns results rating' do
      RegisterRatingService.from(user).for(rateable).register_rate
      rateable.reload

      likes = rateable.user_marks.where(mark: true).count
      dislikes = rateable.user_marks.where(mark: false).count

      expect(rateable.rating).to eq likes - dislikes
    end
  end

  describe '#rated_by?' do
    it 'user already rates rateable' do
      RegisterRatingService.from(user).for(rateable).register_rate
      rateable.reload

      expect(rateable).to be_rated_by(user)
    end

    context 'user does not rate rateable before' do
      it { expect(rateable).not_to be_rated_by(user) }
    end
  end
end
