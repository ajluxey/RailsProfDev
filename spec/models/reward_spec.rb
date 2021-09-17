RSpec.describe Reward, type: :model do
  it { should belong_to(:question)            }
  it { should belong_to(:respondent).optional }


  it { should validate_presence_of :name  }
  it { should have_one_attached    :image }

  it { is_expected.to validate_content_type_of(:image).allowing('image/png', 'image/jpeg') }
end
