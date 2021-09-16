FactoryBot.define do
  factory :reward do
    name       { "MyString" }
    respondent { nil        }
    question
    image { Rack::Test::UploadedFile.new("#{Rails.root}/tmp/test_images/congrats.jpg", 'image/jpg') }
  end
end
