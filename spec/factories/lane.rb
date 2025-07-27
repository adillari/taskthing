FactoryBot.define do
  factory :lane do
    association :board
    sequence(:name) { |n| "Lane #{n}" }
    sequence(:position) { |n| n }

    trait :with_tasks do
      after(:create) do |lane|
        create_list(:task, 3, lane: lane)
      end
    end

    trait :not_started do
      name { "Not Started" }
      position { 0 }
    end

    trait :in_progress do
      name { "In Progress" }
      position { 1 }
    end

    trait :done do
      name { "Done 🎉" }
      position { 2 }
    end
  end
end

