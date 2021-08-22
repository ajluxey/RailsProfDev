FactoryBot.define do
  factory :question do
    title { "MyString" }
    body { "MyText" }

    trait :updated do
      title { "MyNewString" }
      body { "MyNewText" }
    end

    trait :invalid do
      title { nil }
    end
  end
end
