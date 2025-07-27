require "rails_helper"

RSpec.describe User, type: :model do
  describe "validations" do
    subject { build(:user, password: "password123", password_confirmation: "password123") }

    # has_secure_password adds these validations
    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to validate_confirmation_of(:password) }
    
    it "validates password presence" do
      user = build(:user, password: "", password_confirmation: "")
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("can't be blank")
    end
  end

  describe "associations" do
    it { is_expected.to have_many(:sessions).dependent(:destroy) }
    it { is_expected.to have_many(:board_users) }
    it { is_expected.to have_many(:boards).through(:board_users) }
    it { is_expected.to have_many(:owned_boards).through(:board_users) }
    it { is_expected.to have_many(:lanes).through(:boards) }
    it { is_expected.to have_many(:tasks).through(:lanes) }
    it { is_expected.to have_many(:invites) }
  end

  describe "normalizations" do
    it "normalizes email_address to lowercase and strips whitespace" do
      user = build(:user, email_address: "  TEST@EXAMPLE.COM  ")
      user.valid?
      expect(user.email_address).to eq("test@example.com")
    end
  end

  describe "password security" do
    it "has secure password" do
      user = create(:user, password: "password123", password_confirmation: "password123")
      expect(user.authenticate("password123")).to be_truthy
      expect(user.authenticate("wrongpassword")).to be_falsey
    end
  end

  describe "board associations" do
    let(:user) { create(:user) }
    let(:board) { create(:board) }

    before do
      create(:board_user, user: user, board: board, role: "admin")
      create(:board_user, user: user, board: create(:board), role: "member")
    end

    it "returns all boards the user has access to" do
      expect(user.boards.count).to eq(2)
    end

    it "returns only boards where user is admin" do
      expect(user.owned_boards.count).to eq(1)
      expect(user.owned_boards.first).to eq(board)
    end
  end

  describe "nested attributes" do
    it "accepts nested attributes for board_users" do
      user = build(:user)
      expect(user).to accept_nested_attributes_for(:board_users)
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
        user = build(:user, email_address: email)
        expect(user).to be_valid
      end
    end

    it "accepts invalid email addresses (since no validation is enforced)" do
      invalid_emails = [
        "invalid-email",
        "@example.com",
        "user@",
        "user@.com"
      ]

      invalid_emails.each do |email|
        user = build(:user, email_address: email)
        expect(user).to be_valid
      end
    end
  end

  describe "factory" do
    it "creates a valid user" do
      user = build(:user)
      expect(user).to be_valid
    end

    it "creates user with boards" do
      user = create(:user, :with_boards)
      expect(user.boards.count).to eq(2)
    end

    it "creates admin user" do
      user = create(:user, :admin)
      expect(user.owned_boards.count).to eq(1)
    end
  end
end 