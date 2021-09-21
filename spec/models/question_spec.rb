RSpec.describe Question, type: :model do
  it_behaves_like "rateable"
  it_behaves_like "commentable"

  it { should belong_to :author                          }
  it { should have_many(:answers).dependent(:destroy)    }
  it { should have_many(:links).dependent(:destroy)      }
  it { should have_one(:reward).dependent(:destroy)      }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body  }

  it { should accept_nested_attributes_for(:links).allow_destroy(true)  }
  it { should accept_nested_attributes_for(:reward)                     }


  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe '#best_answer' do
    let(:question) { create(:question) }

    context 'when have best answer' do
      let!(:answer) { create(:answer, question: question, best: true) }

      it 'returns it' do
        expect(question.best_answer).to eq answer
      end
    end

    context 'when have not best answer' do
      let!(:answer) { create(:answer, question: question) }

      it 'returns nil' do
        expect(question.best_answer).to be_nil
      end
    end
  end
end
