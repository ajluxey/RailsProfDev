FactoryBot.define do
  factory(:user_rating) do
    mark { true }
    user
    association :rateable, factory: :answer
  end
end
