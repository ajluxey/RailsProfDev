RSpec.describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, :all       }
    it { should_not be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create(:user) }

    it { should be_able_to :read, :all       }
    it { should_not be_able_to :manage, :all }

    it { should be_able_to :create, Answer   }
    it { should be_able_to :create, Question }
    it { should be_able_to :create, Comment  }

    it { should be_able_to :update, Answer, author: user   }
    it { should be_able_to :update, Question, author: user }

    it { should be_able_to :destroy, Answer, author: user   }
    it { should be_able_to :destroy, Question, author: user }
  end
end
