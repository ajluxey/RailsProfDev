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
  end
end
