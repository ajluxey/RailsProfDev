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
  end
end
