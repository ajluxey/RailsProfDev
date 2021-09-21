shared_examples "commentable" do
  let(:model)       { described_class                     }
  let(:user)        { create(:user)                       }
  let(:commenatble) { create(model.to_s.uderscore.to_sym) }

  it { should have_many(:comments).dependent(:destroy) }
end
