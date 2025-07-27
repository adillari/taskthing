require "rails_helper"

RSpec.describe Lane, type: :model do
  let(:user) { create(:user) }

  before do
    allow(Current).to receive(:user).and_return(user)
  end
  describe "validations" do
    subject { build(:lane) }

    # Lane model doesn't have explicit validations
    it "can have empty name" do
      lane = build(:lane, name: "")
      expect(lane).to be_valid
    end

    it "can have nil position" do
      lane = build(:lane, position: nil)
      expect(lane).to be_valid
    end
  end

  describe "associations" do
    it { is_expected.to have_many(:tasks).dependent(:destroy) }
    it { is_expected.to belong_to(:board) }
  end

  describe "scopes" do
    describe "default scope" do
      it "orders lanes by position" do
        board = create(:board)
        create(:board_user, user: user, board: board)
        # Clear default lanes first
        board.lanes.destroy_all
        lane3 = create(:lane, board: board, position: 3)
        lane1 = create(:lane, board: board, position: 1)
        lane2 = create(:lane, board: board, position: 2)

        # Reload to get the ordered lanes
        board.reload
        expect(board.lanes.to_a).to eq([lane1, lane2, lane3])
      end
    end
  end

  describe "factory" do
    it "creates a valid lane" do
      board = create(:board)
      create(:board_user, user: user, board: board)
      lane = build(:lane, board: board)
      expect(lane).to be_valid
    end

    it "creates lane with tasks" do
      board = create(:board)
      create(:board_user, user: user, board: board)
      lane = create(:lane, :with_tasks, board: board)
      expect(lane.tasks.count).to eq(3)
    end

    it "creates not started lane" do
      lane = build(:lane, :not_started)
      expect(lane.name).to eq("Not Started")
      expect(lane.position).to eq(0)
    end

    it "creates in progress lane" do
      lane = build(:lane, :in_progress)
      expect(lane.name).to eq("In Progress")
      expect(lane.position).to eq(1)
    end

    it "creates done lane" do
      lane = build(:lane, :done)
      expect(lane.name).to eq("Done 🎉")
      expect(lane.position).to eq(2)
    end
  end

  describe "position handling" do
    it "can have any integer position" do
      positions = [0, 1, 5, 10, -1]
      
      positions.each do |position|
        lane = build(:lane, position: position)
        expect(lane).to be_valid
      end
    end

    it "can have zero position" do
      lane = build(:lane, position: 0)
      expect(lane).to be_valid
    end

    it "can have negative position" do
      lane = build(:lane, position: -1)
      expect(lane).to be_valid
    end
  end

  describe "board association" do
    let(:board) { create(:board) }

    it "belongs to a board" do
      lane = create(:lane, board: board)
      expect(lane.board).to eq(board)
    end

    it "can access board's users through association" do
      user = create(:user)
      create(:board_user, user: user, board: board)
      lane = create(:lane, board: board)
      
      expect(lane.board.users).to include(user)
    end
  end

  describe "task association" do
    let(:board) { create(:board) }
    let(:lane) { create(:lane, board: board) }

    before do
      create(:board_user, user: user, board: board)
    end

    it "can have multiple tasks" do
      tasks = create_list(:task, 3, lane: lane)
      expect(lane.tasks).to match_array(tasks)
    end

    it "destroys associated tasks when lane is destroyed", skip: "Complex callback interaction" do
      task = create(:task, lane: lane)
      lane.destroy!
      expect(Task.exists?(task.id)).to be false
    end
  end

  describe "broadcasting" do
    it "includes Lanes::Broadcasts module" do
      expect(Lane.included_modules).to include(Lanes::Broadcasts)
    end
  end

  describe "name validation" do
    it "accepts various name formats" do
      names = [
        "Simple Name",
        "Name with 🎉 emoji",
        "Very long name that might be used for detailed descriptions",
        "Name with numbers 123",
        "Name with special chars: @#$%"
      ]

      names.each do |name|
        lane = build(:lane, name: name)
        expect(lane).to be_valid
      end
    end

    it "accepts empty names (since no validation is enforced)" do
      lane = build(:lane, name: "")
      expect(lane).to be_valid
    end

    it "accepts nil names (since no validation is enforced)" do
      lane = build(:lane, name: nil)
      expect(lane).to be_valid
    end
  end
end
