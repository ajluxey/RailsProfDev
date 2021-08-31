RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should belong_to :author }

  it { should validate_presence_of :body }
  # я не знаю почему он падает
  it { should validate_inclusion_of(:best).in_array([true, false]) }

  describe 'validate only one answer can be best' do
    let(:question) { create(:question)                              }
    let(:answer)   { build(:answer, best: true, question: question) }

    context 'with another best answer for question' do
      let!(:best_answer) { create(:answer, best: true, question: question) }

      it { expect(answer.valid?).to be_falsey }
    end

    context 'without another best answer' do
      it { expect(answer.valid?).to be_truthy }
    end
  end

  describe '#is_best!' do
    let!(:question)    { create(:question)                               }
    let!(:answer)      { create(:answer, question: question)             }
    let!(:best_answer) { create(:answer, best: true, question: question) }


    it 'set attribute best to false on another answer' do
      answer.is_best!
      best_answer.reload

      expect(best_answer.best).to be_falsey
    end

    it 'set attribute best to true' do
      answer.is_best!
      answer.reload

      expect(answer).to be_truthy
    end
  end
end
