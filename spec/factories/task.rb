FactoryBot.define do
  factory :task do
    association :lane
    transient do
      base_title { "Task" }
    end
    sequence(:title) { |n| "#{base_title} #{n}" }
    description { "This is a sample task description" }
    sequence(:position) { |n| n }

    trait :with_description do
      description { "A detailed task description with multiple lines.\nIt can contain formatting and additional information." }
    end

    trait :without_description do
      description { nil }
    end

    trait :high_priority do
      transient do
        base_title { "🔥 Task" }
      end
    end

    trait :completed do
      transient do
        base_title { "✅ Task" }
      end
    end
  end
end 