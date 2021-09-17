RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url  }

  it { should allow_values('https://foo.com', 'https://bar.ru').for(:url) }
  it { should_not allow_values('foo.com', 'bar').for(:url)                }
end
