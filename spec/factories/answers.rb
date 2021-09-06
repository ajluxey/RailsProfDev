FactoryBot.define do
  factory :answer do
    body { "MyText" }
    best { false }
    question
    association :author, factory: :user

    trait :updated do
      body { "MyNewText" }
    end

    trait :invalid do
      body { nil }
    end

    factory :answer_with_file do
      after(:build) do |answer|
        answer.files.attach(
          io: File.open(Rails.root.join('spec', 'rails_helper.rb')),
          filename: 'rails_helper.rb',
          content_type: 'text/plain'
        )
      end
    end
  end
end
