FactoryBot.define do
  factory :invite do
    association :user
    association :board
    sequence(:email_address) { |n| "invite#{n}@example.com" }

    trait :with_email do
      email_address { "specific@example.com" }
    end

    trait :without_email do
      email_address { nil }
    end
  end
end

