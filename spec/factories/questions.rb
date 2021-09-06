FactoryBot.define do
  factory :question do
    title { "MyString" }
    body { "MyText" }
    association :author, factory: :user

    trait :updated do
      title { "MyNewString" }
      body { "MyNewText" }
    end

    trait :invalid do
      title { nil }
    end

    factory :question_with_file do
      after(:build) do |question|
        question.files.attach(
          io: File.open(Rails.root.join('spec', 'rails_helper.rb')),
          filename: 'rails_helper.rb',
          content_type: 'text/plain'
        )
      end
    end
  end
end
