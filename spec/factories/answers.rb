FactoryBot.define do
  factory :answer do
    body { "MyText" }
    correct { false }
    question

    trait :updated do
      body { "MyNewText" }
      correct { true }
    end

    trait :invalid do
      body { nil }
    end
  end
end
