require "rails_helper"

RSpec.describe Invite, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:board) }
  end

  describe "factory" do
    it "creates a valid invite" do
      invite = build(:invite)
      expect(invite).to be_valid
    end

    it "creates invite with specific email" do
      invite = build(:invite, :with_email)
      expect(invite.email_address).to eq("specific@example.com")
    end

    it "creates invite without email" do
      invite = build(:invite, :without_email)
      expect(invite.email_address).to be_nil
    end
  end

  describe "email handling" do
    it "can have an email address" do
      email = "test@example.com"
      invite = build(:invite, email_address: email)
      expect(invite.email_address).to eq(email)
    end

    it "can have nil email address" do
      invite = build(:invite, email_address: nil)
      expect(invite).to be_valid
    end

    it "can have empty email address" do
      invite = build(:invite, email_address: "")
      expect(invite).to be_valid
    end
  end

  describe "user association" do
    let(:user) { create(:user) }

    it "belongs to a user" do
      invite = create(:invite, user: user)
      expect(invite.user).to eq(user)
    end

    it "can access user's boards through association" do
      board = create(:board)
      create(:board_user, user: user, board: board)
      invite = create(:invite, user: user)
      
      expect(invite.user.boards).to include(board)
    end
  end

  describe "board association" do
    let(:board) { create(:board) }

    it "belongs to a board" do
      invite = create(:invite, board: board)
      expect(invite.board).to eq(board)
    end

    it "can access board's users through association" do
      user = create(:user)
      create(:board_user, user: user, board: board)
      invite = create(:invite, board: board)
      
      expect(invite.board.users).to include(user)
    end
  end

  describe "uniqueness constraints" do
    let(:user) { create(:user) }
    let(:board) { create(:board) }

    it "allows multiple invites for different boards" do
      create(:invite, user: user, board: board)
      new_board = create(:board)
      new_invite = build(:invite, user: user, board: new_board)
      expect(new_invite).to be_valid
    end

    it "allows multiple invites for different users" do
      create(:invite, user: user, board: board)
      new_user = create(:user)
      new_invite = build(:invite, user: new_user, board: board)
      expect(new_invite).to be_valid
    end
  end

  describe "email format validation" do
    it "accepts valid email addresses" do
      valid_emails = [
        "test@example.com",
        "user.name@domain.co.uk",
        "user+tag@example.org"
      ]

      valid_emails.each do |email|
        invite = build(:invite, email_address: email)
        expect(invite).to be_valid
      end
    end

    it "accepts invalid email addresses (since validation is not enforced)" do
      invalid_emails = [
        "invalid-email",
        "@example.com",
        "user@",
        "user@.com"
      ]

      invalid_emails.each do |email|
        invite = build(:invite, email_address: email)
        expect(invite).to be_valid
      end
    end
  end

  describe "timestamps" do
    it "has created_at timestamp" do
      invite = create(:invite)
      expect(invite.created_at).to be_present
    end

    it "has updated_at timestamp" do
      invite = create(:invite)
      expect(invite.updated_at).to be_present
    end
  end
end
