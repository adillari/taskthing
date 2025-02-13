class BoardUser < ApplicationRecord
  ROLES = ["admin", "member"].freeze
  validates :role, inclusion: { in: ROLES }
  belongs_to :user
  belongs_to :board
end
