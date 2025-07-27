FactoryBot.define do
  factory :session do
    association :user
    ip_address { "192.168.1.1" }
    user_agent { "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36" }

    trait :mobile do
      user_agent { "Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X) AppleWebKit/605.1.15" }
    end

    trait :desktop do
      user_agent { "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36" }
    end
  end
end

