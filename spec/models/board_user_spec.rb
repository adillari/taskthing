require "rails_helper"

RSpec.describe BoardUser, type: :model do
  describe "validations" do
    subject { build(:board_user) }

    it { is_expected.to validate_inclusion_of(:role).in_array(BoardUser::ROLES) }
  end

  describe "associations" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:board) }
  end

  describe "constants" do
    it "defines valid roles" do
      expect(BoardUser::ROLES).to match_array(["admin", "member"])
    end
  end

  describe "role methods" do
    describe "#admin?" do
      it "returns true for admin role" do
        board_user = build(:board_user, :admin)
        expect(board_user.admin?).to be true
      end

      it "returns false for member role" do
        board_user = build(:board_user, :member)
        expect(board_user.admin?).to be false
      end
    end

    describe "#member?" do
      it "returns true for member role" do
        board_user = build(:board_user, :member)
        expect(board_user.member?).to be true
      end

      it "returns false for admin role" do
        board_user = build(:board_user, :admin)
        expect(board_user.member?).to be false
      end
    end
  end

  describe "factory" do
    it "creates a valid board_user" do
      board_user = build(:board_user)
      expect(board_user).to be_valid
    end

    it "creates admin board_user" do
      board_user = build(:board_user, :admin)
      expect(board_user.role).to eq("admin")
      expect(board_user.admin?).to be true
    end

    it "creates member board_user" do
      board_user = build(:board_user, :member)
      expect(board_user.role).to eq("member")
      expect(board_user.member?).to be true
    end
  end

  describe "role validation" do
    it "accepts valid roles" do
      BoardUser::ROLES.each do |role|
        board_user = build(:board_user, role: role)
        expect(board_user).to be_valid
      end
    end

    it "rejects invalid roles" do
      invalid_roles = ["owner", "guest", "moderator", ""]
      
      invalid_roles.each do |role|
        board_user = build(:board_user, role: role)
        expect(board_user).not_to be_valid
        expect(board_user.errors[:role]).to be_present
      end
    end
  end

  describe "uniqueness constraints" do
    let(:user) { create(:user) }
    let(:board) { create(:board) }

    it "allows multiple board_users for different boards" do
      create(:board_user, user: user, board: board)
      new_board = create(:board)
      new_board_user = build(:board_user, user: user, board: new_board)
      expect(new_board_user).to be_valid
    end

    it "allows multiple board_users for different users" do
      create(:board_user, user: user, board: board)
      new_user = create(:user)
      new_board_user = build(:board_user, user: new_user, board: board)
      expect(new_board_user).to be_valid
    end
  end

  describe "position handling" do
    it "can have a position" do
      board_user = build(:board_user, position: 5)
      expect(board_user.position).to eq(5)
    end

    it "can have nil position" do
      board_user = build(:board_user, position: nil)
      expect(board_user).to be_valid
    end
  end
end
