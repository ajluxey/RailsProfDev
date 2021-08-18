FactoryBot.define do
  factory :answer do
    body { "MyText" }
    correct { false }
    question

    trait :invalid do
      body { nil }
    end
  end
end
