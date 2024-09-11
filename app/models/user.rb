class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :boards
  has_many :lanes, through: :boards

  normalizes :email_address, with: -> { _1.strip.downcase }
end
