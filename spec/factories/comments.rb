FactoryBot.define do
  factory :comment do
    body { "MyText" }
    association :author, factory: :user
    association :rateable, factory: :answer
  end
end
