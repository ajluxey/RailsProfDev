FactoryBot.define do
  factory :link do
    name { "MyString"           }
    url  { "https://github.com" }
    association :linkable, factory: :question

    trait :new do
      name { 'NewString' }
    end

    trait :gist do
      url { 'https://gist.github.com/ajluxey/b20c9c60f9b4c563733bd2b49942be7d' }
    end
  end
end
