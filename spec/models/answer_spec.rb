RSpec.describe Answer, type: :model do
  it { should belong_to :question                   }
  it { should belong_to :author                     }
  it { should have_many(:links).dependent(:destroy) }

  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }

  describe ':best validate inclusion of true false' do
    context 'with valid entry' do
      [true, false, 1, 0].each do |value|
        it { expect(build(:answer, best: value)).to be_valid }
      end
    end

    context 'with invalid entry' do
      [nil, ''].each do |value|
        it { expect(build(:answer, best: value)).not_to be_valid }
      end
    end
  end

  it 'have many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe ':best validate one best answer' do
    let(:question) { create(:question)                              }
    let(:answer)   { build(:answer, best: true, question: question) }

    context 'with another best answer for question' do
      let!(:best_answer) { create(:answer, best: true, question: question) }

      it { expect(answer).not_to be_valid }
    end

    context 'without another best answer' do
      it { expect(answer).to be_valid }
    end

    context 'when saved best answer updated' do
      let(:answer) { create(:answer, best: true) }

      it { expect(answer).to be_valid }
    end
  end

  describe '#is_best!' do
    let!(:question) { create(:question)                   }
    let!(:answer)   { create(:answer, question: question) }

    it 'set attribute best to true' do
      answer.is_best!
      answer.reload

      expect(answer.best).to be_truthy
    end

    context 'when another best answer present' do
      let!(:best_answer) { create(:answer, best: true, question: question) }

      it 'sets attribute best to false on actual best answer of question' do
        answer.is_best!
        best_answer.reload

        expect(best_answer.best).to be_falsey
      end

      it 'return previous best' do
        expect(answer.is_best!).to eq best_answer
      end
    end
  end
end
