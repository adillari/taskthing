require "rails_helper"

RSpec.describe Board, type: :model do
  let(:user) { create(:user) }

  before do
    allow(Current).to receive(:user).and_return(user)
  end
  describe "validations" do
    subject { build(:board) }

    it "requires title to be present" do
      board = build(:board, title: "")
      expect(board).not_to be_valid
      expect(board.errors[:title]).to include("can't be blank")
    end

    it "is valid with a title" do
      board = build(:board, title: "Valid Title")
      expect(board).to be_valid
    end
  end

  describe "associations" do
    it { is_expected.to have_many(:board_users).dependent(:destroy) }
    it { is_expected.to have_many(:users).through(:board_users) }
    it { is_expected.to have_many(:invites).dependent(:destroy) }
    it { is_expected.to have_many(:lanes).dependent(:destroy) }
    it { is_expected.to have_many(:tasks).through(:lanes) }
  end

  describe "nested attributes" do
    it "accepts nested attributes for lanes" do
      board = build(:board)
      expect(board).to accept_nested_attributes_for(:lanes).allow_destroy(true)
    end
  end

  describe "callbacks" do
    describe "after_create_commit" do
      it "creates default lanes when board is created" do
        board = create(:board)
        
        expect(board.lanes.count).to eq(3)
        expect(board.lanes.pluck(:name)).to match_array([
          "Not Started",
          "In Progress", 
          "Done 🎉"
        ])
        expect(board.lanes.pluck(:position)).to match_array([0, 1, 2])
      end

      it "does not create default lanes if lanes already exist" do
        board = build(:board)
        board.lanes.build(name: "Custom Lane", position: 0)
        board.save!
        
        expect(board.lanes.count).to eq(1)
        expect(board.lanes.first.name).to eq("Custom Lane")
      end
    end
  end

  describe "#bump_version!" do
    it "increments the version by 1" do
      board = create(:board, version: 5)
      board.bump_version!
      expect(board.version).to eq(6)
    end

    it "saves the record" do
      board = create(:board, version: 1)
      board.bump_version!
      board.reload
      expect(board.version).to eq(2)
    end
  end

  describe "factory" do
    it "creates a valid board" do
      board = build(:board)
      expect(board).to be_valid
    end

    it "creates board with users" do
      board = create(:board, :with_users)
      expect(board.users.count).to eq(2)
    end

    it "creates board with lanes" do
      board = create(:board, :with_lanes)
      expect(board.lanes.count).to eq(3)
    end

    it "creates board with tasks" do
      board = create(:board, :with_tasks)
      expect(board.tasks.count).to eq(6) # 2 lanes * 3 tasks each
    end
  end

  describe "default lanes creation" do
    let(:board) { create(:board) }

    it "creates lanes in correct order" do
      lanes = board.lanes.order(:position)
      expect(lanes[0].name).to eq("Not Started")
      expect(lanes[0].position).to eq(0)
      expect(lanes[1].name).to eq("In Progress")
      expect(lanes[1].position).to eq(1)
      expect(lanes[2].name).to eq("Done 🎉")
      expect(lanes[2].position).to eq(2)
    end

    it "associates lanes with the board" do
      board.lanes.each do |lane|
        expect(lane.board).to eq(board)
      end
    end
  end

  describe "version management" do
    it "starts with version 1" do
      board = create(:board)
      expect(board.version).to eq(1)
    end

    it "can be updated multiple times" do
      board = create(:board)
      3.times { board.bump_version! }
      expect(board.version).to eq(4)
    end
  end
end
