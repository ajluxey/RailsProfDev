FactoryBot.define do
  factory :answer do
    body { "MyText" }
    correct { false }
    question
    association :author, factory: :user

    trait :updated do
      body { "MyNewText" }
      correct { true }
    end

    trait :invalid do
      body { nil }
    end
  end
end
