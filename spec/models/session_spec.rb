require "rails_helper"

RSpec.describe Session, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:user) }
  end

  describe "factory" do
    it "creates a valid session" do
      session = build(:session)
      expect(session).to be_valid
    end

    it "creates mobile session" do
      session = build(:session, :mobile)
      expect(session.user_agent).to include("iPhone")
    end

    it "creates desktop session" do
      session = build(:session, :desktop)
      expect(session.user_agent).to include("Macintosh")
    end
  end

  describe "user association" do
    let(:user) { create(:user) }

    it "belongs to a user" do
      session = create(:session, user: user)
      expect(session.user).to eq(user)
    end

    it "can access user's boards through association" do
      board = create(:board)
      create(:board_user, user: user, board: board)
      session = create(:session, user: user)
      
      expect(session.user.boards).to include(board)
    end
  end

  describe "ip_address handling" do
    it "can have an ip address" do
      ip = "192.168.1.100"
      session = build(:session, ip_address: ip)
      expect(session.ip_address).to eq(ip)
    end

    it "can have nil ip address" do
      session = build(:session, ip_address: nil)
      expect(session).to be_valid
    end

    it "can have empty ip address" do
      session = build(:session, ip_address: "")
      expect(session).to be_valid
    end

    it "accepts various ip address formats" do
      ips = [
        "192.168.1.1",
        "10.0.0.1",
        "172.16.0.1",
        "127.0.0.1",
        "::1"
      ]

      ips.each do |ip|
        session = build(:session, ip_address: ip)
        expect(session).to be_valid
      end
    end
  end

  describe "user_agent handling" do
    it "can have a user agent" do
      ua = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
      session = build(:session, user_agent: ua)
      expect(session.user_agent).to eq(ua)
    end

    it "can have nil user agent" do
      session = build(:session, user_agent: nil)
      expect(session).to be_valid
    end

    it "can have empty user agent" do
      session = build(:session, user_agent: "")
      expect(session).to be_valid
    end

    it "accepts various user agent formats" do
      user_agents = [
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36",
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36",
        "Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X) AppleWebKit/605.1.15",
        "Mozilla/5.0 (Android 10; Mobile) AppleWebKit/537.36",
        "curl/7.68.0"
      ]

      user_agents.each do |ua|
        session = build(:session, user_agent: ua)
        expect(session).to be_valid
      end
    end
  end

  describe "timestamps" do
    it "has created_at timestamp" do
      session = create(:session)
      expect(session.created_at).to be_present
    end

    it "has updated_at timestamp" do
      session = create(:session)
      expect(session.updated_at).to be_present
    end
  end

  describe "multiple sessions per user" do
    let(:user) { create(:user) }

    it "allows multiple sessions for the same user" do
      session1 = create(:session, user: user, ip_address: "192.168.1.1")
      session2 = create(:session, user: user, ip_address: "192.168.1.2")
      
      expect(user.sessions.count).to eq(2)
      expect(user.sessions).to include(session1, session2)
    end

    it "allows sessions with same ip address" do
      create(:session, user: user, ip_address: "192.168.1.1")
      session2 = build(:session, user: user, ip_address: "192.168.1.1")
      expect(session2).to be_valid
    end

    it "allows sessions with same user agent" do
      ua = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
      create(:session, user: user, user_agent: ua)
      session2 = build(:session, user: user, user_agent: ua)
      expect(session2).to be_valid
    end
  end
end 