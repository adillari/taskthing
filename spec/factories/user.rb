FactoryBot.define do
  factory :user do
    id { 1 }
    email_address { "geohot@comma.ai" }
    password_digest { "realpassworddigest" }
  end
end
