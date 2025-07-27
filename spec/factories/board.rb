FactoryBot.define do
  factory :board do
    sequence(:title) { |n| "Board #{n}" }
    version { 1 }

    trait :with_users do
      after(:create) do |board|
        create_list(:board_user, 2, board: board)
      end
    end

    trait :with_lanes do
      after(:create) do |board|
        # Skip default lanes creation and add custom lanes
        board.lanes.destroy_all
        create_list(:lane, 3, board: board)
      end
    end

    trait :with_tasks do
      after(:create) do |board|
        # Ensure current user has access to the board
        if Current.user
          create(:board_user, user: Current.user, board: board, role: "admin")
        end
        lanes = create_list(:lane, 2, board: board)
        lanes.each do |lane|
          create_list(:task, 3, lane: lane)
        end
      end
    end
  end
end

