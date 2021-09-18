RSpec.describe UserRating, type: :model do
  subject!(:user_rating) { create(:user_rating) }

  it { should belong_to :user     }
  it { should belong_to :rateable }

  it { should validate_inclusion_of(:mark).in_array([true, false]) }

  describe '#validate_author_can_not_rate' do
    let(:user)          { create(:user)                                       }
    let(:rateable)      { create(:answer, author: user)                       }
    let(:user_rating)   { build(:user_rating)                                 }
    let(:author_rating) { build(:user_rating, user: user, rateable: rateable) }

    it 'validates that author of rateable resource tries to rates' do
      expect(author_rating).not_to be_valid
    end

    it 'validates that user tries to rates' do
      expect(user_rating).to be_valid
    end
  end
end
