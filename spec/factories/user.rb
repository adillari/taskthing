FactoryBot.define do
  factory :user do
    sequence(:email_address) { |n| "user#{n}@example.com" }
    password { "password123" }
    password_confirmation { "password123" }

    trait :with_boards do
      after(:create) do |user|
        create_list(:board_user, 2, user: user)
      end
    end

    trait :admin do
      after(:create) do |user|
        create(:board_user, user: user, role: "admin")
      end
    end
  end
end
