FactoryBot.define do
  factory :reward do
    name       { "MyString" }
    respondent { nil        }
    question
    image { Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/images/congrats.jpg", 'image/jpg') }
  end
end
