RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should belong_to :author }

  it { should validate_presence_of :body }
  it { should validate_inclusion_of(:best).in_array([true, false]) }

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
