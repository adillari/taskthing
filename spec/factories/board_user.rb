FactoryBot.define do
  factory :board_user do
    association :user
    association :board
    role { "member" }
    position { rand(0..100) }

    trait :admin do
      role { "admin" }
    end

    trait :member do
      role { "member" }
    end
  end
end

