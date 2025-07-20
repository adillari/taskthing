class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :board_users
  has_many :boards, through: :board_users
  has_many :owned_boards, -> { where(board_users: { role: "admin" }) }, through: :board_users, source: :board
  has_many :lanes, through: :boards
  has_many :tasks, through: :lanes
  has_many :invites
  accepts_nested_attributes_for :board_users

  validates_uniqueness_of :email_address
  normalizes :email_address, with: -> { _1.strip.downcase }
end
