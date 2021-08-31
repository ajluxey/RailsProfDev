RSpec.describe Question, type: :model do
  it { should belong_to :author }
  it { should have_many :answers }
  it { should have_many(:answers).dependent(:destroy) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  describe '#remove_best_answer' do
    let(:question) { create(:question)                                  }
    let(:answers)  { create(:answer, 4, best: true, question: question) }

    it 'sets attribute best to false for all answers' do
      question.remove_best_answer

      expect(question.answers.where(best: true).count).to eq 0
    end
  end
end
