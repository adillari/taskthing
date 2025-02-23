class BoardUser < ApplicationRecord
  ROLES = ["admin", "member"].freeze
  validates :role, inclusion: { in: ROLES }
  belongs_to :user
  belongs_to :board

  def admin?
    role == "admin"
  end

  def member?
    role == "member"
  end
end
